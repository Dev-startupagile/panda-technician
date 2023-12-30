// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, await_only_futures

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/components/globalComponents/TextFiledCustom.dart';
import 'package:panda_technician/components/globalComponents/popUpMessage.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/core/constants/theme/app_icons.dart';
import 'package:panda_technician/models/messages/message.dart';
import 'package:panda_technician/models/auth/signUp.dart';
import 'package:panda_technician/screens/auth/social_login_widget.dart';
import 'package:panda_technician/services/validationServices.dart';

class SignUpMethodScreen extends StatefulWidget {
  const SignUpMethodScreen({super.key});

  @override
  State<SignUpMethodScreen> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<SignUpMethodScreen> {
  SignUp userDetail = SignUp();

  var confirmedPassword = "";
  var errorForm = 0;
  var toBeconfirmed = "";
  var updated = true;

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    confirmedPassword = "";
    updated = true;
  }

  ApiHandler _apiHandler = ApiHandler();

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
                SizedBox(height: 50),
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
                          userDetail.email = value;
                        }), // this is to avoid they are watching me so i wont' be doing what they are thiking about
                        preIcon: Icons.email,
                        hintText: "Email",
                        isPassword: false,
                        isZipCode: false,
                        isEmail: true,
                        isNumber: false,
                        isError: errorForm == 5,
                      ),
                      TextFiledCustom(
                        updateCallback: ((value) {
                          userDetail.password = value;
                          if (is8Char(value) &&
                              containsLowerCase(value) &&
                              containsUpperCase(value) &&
                              containsSymbols(value) &&
                              containsNumb(value)) {
                            errorForm = 0;
                          }
                          setState(() {
                            confirmedPassword = value;
                            updated = !updated;
                          });
                        }),
                        preIcon: Icons.person,
                        hintText: "Password",
                        isPassword: true,
                        isZipCode: false,
                        isEmail: false,
                        isNumber: false,
                        isError: errorForm == 4,
                      ),
                      if (userDetail.password.isNotEmpty)
                        Container(
                          width: 340,
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Icon(
                                  color: is8Char(userDetail.password)
                                      ? Colors.green[400]
                                      : Colors.grey[600],
                                  Icons.circle,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 11),
                                    "Minimem 8 charachters")
                              ]),
                              const SizedBox(
                                width: 5,
                              ),
                              Row(children: <Widget>[
                                Icon(
                                  color: containsNumb(userDetail.password)
                                      ? Colors.green[400]
                                      : Colors.grey[600],
                                  Icons.circle,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 11),
                                    "Numbers[0-9]")
                              ]),
                            ],
                          ),
                        ),
                      if (userDetail.password.isNotEmpty)
                        Container(
                          width: 340,
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Icon(
                                  color: containsLowerCase(userDetail.password)
                                      ? Colors.green[400]
                                      : Colors.grey[600],
                                  Icons.circle,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 11),
                                    "LowerCase Letters[a-z]")
                              ]),
                              const SizedBox(
                                width: 10,
                              ),
                              Row(children: <Widget>[
                                Icon(
                                  color: containsUpperCase(userDetail.password)
                                      ? Colors.green[400]
                                      : Colors.grey[600],
                                  Icons.circle,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 11),
                                    "UpperCase Letters[A-Z]")
                              ]),
                            ],
                          ),
                        ),
                      if (userDetail.password.isNotEmpty)
                        Container(
                          width: 340,
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Icon(
                                  color: containsSymbols(userDetail.password)
                                      ? Colors.green[400]
                                      : Colors.grey[600],
                                  Icons.circle,
                                  size: 11,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 11),
                                    "Symbols")
                              ]),
                            ],
                          ),
                        ),
                      TextFiledCustom(
                          updateCallback: ((value) {
                            if (userDetail.password != value) {}
                            toBeconfirmed = value;
                          }),
                          preIcon: Icons.person,
                          hintText: "Confirm Password",
                          isPassword: true,
                          isZipCode: false,
                          isEmail: false,
                          isNumber: false,
                          password: confirmedPassword,
                          isUpdated: updated),
                    ],
                  ),
                ),
                Container(
                    width: 340, //
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(51, 188, 132, 1)),
                    margin: const EdgeInsets.all(10),
                    child: TextButton(
                      onPressed: () async {
                        if (toBeconfirmed != confirmedPassword) {
                          showPurchaseDialog(context, "Error Occured",
                              "Invalid confirmation password",
                              isApiCall: false);
                        } else {
                          Message message = signUpFormValidation0(userDetail);
                          if (message.success) {
                            Get.toNamed("CreateAccount", arguments: userDetail);
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
                        }
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  height: 1,
                                  color:
                                      const Color.fromARGB(255, 79, 78, 78))),
                          const SizedBox(width: 5),
                          const Text("OR"),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Container(
                                  height: 1,
                                  color:
                                      const Color.fromARGB(255, 79, 78, 78))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SocialLoginBtn(
                          fillColor: Colors.white,
                          icon: AppIcons.googleIcon,
                          textColor: const Color.fromRGBO(0, 0, 0, 1),
                          isSignIn: false,
                          onTap: () => _apiHandler.signInWithSocial(
                              false, AvaliableSocialLogin.google),
                          name: "Google"),
                      SocialLoginBtn(
                          fillColor: Colors.white,
                          icon: AppIcons.appleIcon,
                          textColor: Colors.black,
                          isSignIn: false,
                          onTap: () => _apiHandler.signInWithSocial(
                              false, AvaliableSocialLogin.apple),
                          name: "Apple"),
                      SocialLoginBtn(
                          fillColor: const Color(0xff1877f2),
                          icon: AppIcons.facebookIcon,
                          textColor: Colors.white,
                          isSignIn: false,
                          onTap: () => _apiHandler.signInWithSocial(
                              false, AvaliableSocialLogin.facebook),
                          name: "Facebook"),
                    ],
                  ),
                ),
              ]),
        ));
  }
}
