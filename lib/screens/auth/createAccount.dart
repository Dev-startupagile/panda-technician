// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, await_only_futures

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:panda_technician/components/globalComponents/TextFiledCustom.dart';
import 'package:panda_technician/components/loading.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/core/constants/theme/app_color.dart';
import 'package:panda_technician/models/messages/message.dart';
import 'package:panda_technician/models/auth/signUp.dart';
import 'package:panda_technician/services/AWSClient.dart';
import 'package:panda_technician/services/validationServices.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final ImagePicker _picker = ImagePicker();
  // SignUp userDetail = SignUp();
  SignUp userDetail = Get.arguments;

  var errorForm = 0;
  var toBeconfirmed = "";
  var updated = true;

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    userDetail.userRole = "technician";
    updated = true;
  }

  bool phoneAgreed = false;
  PhoneNumber number = PhoneNumber(isoCode: 'US');
  String uriPath = "";
  // Pick an image
  void getImage(String type) async {
    late XFile? image;
    if (type == "CAMERA") {
      image = await _picker.pickImage(source: ImageSource.camera);
    } else {
      image = await _picker.pickImage(source: ImageSource.gallery);
    }
    final path = image!.path;
    File? croped = await _cropImage(path);
    final bytes = await File(croped!.path).readAsBytesSync();

    var timestamp = DateTime.now().millisecondsSinceEpoch;
    Loading(context);

    bool result = await AWSClientCustom()
        .uploadData("panda/image", "$timestamp" + "tech.jpg", bytes);
    if (result) {}

    userDetail.profilePicture = "${dotenv.env['S3_BUCKET_URL']}panda/image/" +
        "$timestamp" +
        "tech.jpg";

    setState(() {
      uriPath = croped!.path;
      Get.back();
    });
  }

  Future<File?> _cropImage(String path) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: const Text("Sign Up", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 140,
                  color: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                          top: 0,
                          width: 140,
                          height: 120,
                          child: GestureDetector(
                              onTap: () {
                                Get.back();

                                getImage("CAMERA");
                              },
                              child: CircleAvatar(
                                maxRadius: 80.0,
                                backgroundColor: Colors.grey.shade400,
                                backgroundImage:
                                    const AssetImage("assets/avater.png"),
                                foregroundImage: uriPath != ""
                                    ? FileImage(File(uriPath))
                                    : AssetImage("assets/avater.png")
                                        as ImageProvider,
                              ))),
                      Positioned(
                          top: 75,
                          left: MediaQuery.of(context).size.width * 0.45,
                          width: 45,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 220,
                                      child: Column(children: [
                                        InkWell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.image,
                                                  size: 28,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Browse Gallery",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            Get.back();

                                            getImage("GALLERY");
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Center(
                                          child: Text(
                                            'OR',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        InkWell(
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 15, 0, 0),
                                            height: 60,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 28,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Use a Camera",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            Get.back();

                                            getImage("CAMERA");
                                          },
                                        ),
                                      ]),
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.primary,
                              size: 45,
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFiledCustom(
                        updateCallback: ((value) {
                          userDetail.firstName = value;
                        }),
                        preIcon: Icons.person,
                        hintText: userDetail.firstName.isEmpty
                            ? "First Name"
                            : userDetail.firstName,
                        isPassword: false,
                        isZipCode: false,
                        isEmail: false,
                        isNumber: false,
                        isError: errorForm == 1,
                      ),
                      TextFiledCustom(
                        updateCallback: ((value) {
                          userDetail.lastName = value;
                        }),
                        preIcon: Icons.person,
                        hintText: userDetail.lastName.isEmpty
                            ? "Last Name"
                            : userDetail.lastName,
                        isPassword: false,
                        isZipCode: false,
                        isEmail: false,
                        isNumber: false,
                        isError: errorForm == 2,
                      ),
                      Container(
                        width: 340,
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InternationalPhoneNumberInput(
                          inputBorder: InputBorder.none,
                          maxLength: Platform.isAndroid ? 12 : 20,
                          onInputChanged: (PhoneNumber number) {
                            userDetail.phoneNumber =
                                number.phoneNumber.toString();
                            controller.selection = TextSelection.collapsed(
                                offset: controller.text.length);
                          },
                          onInputValidated: (bool value) {},
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: number,
                          textFieldController: controller,
                          formatInput: true,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: true),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.9,
                    margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            value: phoneAgreed,
                            onChanged: (bool? value) {
                              setState(() {
                                phoneAgreed = !phoneAgreed;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "By checking this box you agree to receive text messages at the number provided.",
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ])),
                Container(
                    width: 340, //
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary),
                    margin: const EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () async {
                        Message message =
                            signUpFormValidation1(userDetail, phoneAgreed);
                        if (message.success) {
                          Get.toNamed("CreateAccount2", arguments: userDetail);
                        } else {
                          setState(() {
                            errorForm = message.formIndex;
                          });

                          DialogBox(context, "Error Occured", message.message,
                              "Cancel", "Ok", (() {
                            Get.back();
                          }), (() {
                            Get.back();
                          }));
                          // showPurchaseDialog(
                          //     context, "Error Occured", message.message,
                          //     isApiCall: false);
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ]),
        ));
  }
}
