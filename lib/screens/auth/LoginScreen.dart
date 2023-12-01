import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/components/globalComponents/TextFiledCustom.dart';
import 'package:panda_technician/components/loading.dart';
import 'package:panda_technician/components/globalComponents/popUpMessage.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/services/firstTimeRun.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = "";
  var password = "";
  var loaded = false;
  @override
  void initState() {
    super.initState();
    // isAlready();
    email = "baslielselamu2018+tppp@gmail.com";
    password = "Ap2334@56";
  }

  isAlready() {
    bool lod = isAlreadyLoagedIn(context);
    if (!lod) return;
    setState(() {
      loaded = true;
    });
  }

  setEmail(String value) {
    setState(() {
      email = value;
    });
  }

  updateLoaded() {
    setState(() {
      loaded = true;
    });
  }

  setPassword(String value) {
    setState(() {
      password = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: 300,
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 50),
                    child: const Image(
                        image: AssetImage("assets/HeaderLogo.png"))),
                TextFiledCustom(
                    updateCallback: setEmail,
                    preIcon: Icons.person,
                    hintText: email,
                    // hintText: "Email",
                    isPassword: false,
                    isZipCode: false,
                    isEmail: true,
                    isNumber: false),
                const SizedBox(
                  height: 20,
                ),
                TextFiledCustom(
                    updateCallback: setPassword,
                    preIcon: Icons.person,
                    hintText: password,
                    // hintText: "Password",
                    isPassword: true,
                    isZipCode: false,
                    isEmail: false,
                    isNumber: false),
                Container(
                  width: 340,
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      onPressed: () {
                        Get.toNamed(forgetPassword);
                      },
                      child: const Text(
                        "Forget Password?",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(51, 188, 132, 1)),
                        textAlign: TextAlign.left,
                      )),
                ),
                Container(
                    width: 340, //
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(51, 188, 132, 1)),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextButton(
                      onPressed: () async {
                        Loading(context);
                        var response =
                            await ApiHandler().login(email, password);

                        if (response) {
                          // ignore: use_build_context_synchronously
                          Get.offAndToNamed(homePage);
                        } else {
                          // ignore: use_build_context_synchronously
                          showPurchaseDialog(context, "Error Occured",
                              "Wrong user name or password");
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    )),
                Container(
                    width: 400,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Not a member?",
                          style: TextStyle(fontSize: 14, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(createAccount);
                            },
                            child: const Text(
                              " Sign Up Now",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(51, 188, 132, 1),
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ))
                      ],
                    ))
              ],
            ))));
  }
}
