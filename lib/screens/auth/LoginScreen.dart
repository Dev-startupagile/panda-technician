import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/components/globalComponents/TextFiledCustom.dart';
import 'package:panda_technician/components/loading.dart';
import 'package:panda_technician/components/globalComponents/popUpMessage.dart';
import 'package:panda_technician/core/constants/theme/app_icons.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/screens/auth/social_login_widget.dart';

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
    // email = "baslielselamu2018+tppp@gmail.com";
    // password = "LionKing!23";
  }

  ApiHandler _apiHandler = ApiHandler();

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
                    // hintText: email,
                    hintText: "Email",
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
                        color: Color.fromRGBO(51, 188, 132, 1)),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: TextButton(
                      onPressed: () async {
                        Loading(context);
                        var response = await _apiHandler.login(email, password);

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
                              Get.toNamed(signUpMethodScreen);
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
                          isSignIn: true,
                          onTap: () => _apiHandler.signInWithSocial(
                              true, AvaliableSocialLogin.google),
                          name: "Google"),
                      SocialLoginBtn(
                          fillColor: Colors.white,
                          icon: AppIcons.appleIcon,
                          textColor: Colors.black,
                          isSignIn: true,
                          onTap: () => _apiHandler.signInWithSocial(
                              true, AvaliableSocialLogin.apple),
                          name: "Apple"),
                      SocialLoginBtn(
                          fillColor: const Color(0xff1877f2),
                          icon: AppIcons.facebookIcon,
                          textColor: Colors.white,
                          isSignIn: true,
                          onTap: () => _apiHandler.signInWithSocial(
                              true, AvaliableSocialLogin.facebook),
                          name: "Facebook"),
                    ],
                  ),
                ),
              ],
            ))));
  }
}
