import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showPurchaseDialog(BuildContext context, String title, String message,
    {bool isApiCall: true, bool isOtp: false, isVerify: false}) {
  showDialog(
      context: context,
      barrierDismissible:
          false, // disables popup to close if tapped outside popup (need a button to close)
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
          ),
          content: Text(message),
          //buttons?
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                if (isApiCall) {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  if (isOtp) {
                    Get.toNamed("SingUp");
                  }
                  if (isVerify) {
                    Get.toNamed("Verification");
                  }
                } else {
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                  if (isOtp) {
                    Get.toNamed("SingUp");
                  }
                }
              }, //closes popup
            ),
          ],
        );
      });
}

bool test() {
  return true;
}
