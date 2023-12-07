import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/models/review_model.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/widgets/rating_widget.dart';

class DialogHelper {
  static void showGetXLoading() {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        // The background color
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // The loading indicator
              Image.asset(
                "assets/Loading.gif",
                height: 100.0,
                width: 100.0,
              ),
              SizedBox(
                height: 15,
              ),
              // Some text
              Text('Loading...')
            ],
          ),
        ),
      ),
    );
  }

  static void showGetXDialogBox(
      String title,
      String message,
      String negativeButton,
      String positiveButton,
      Function negativeCallBack,
      Function positiveCallBack) {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text(
            title,
          ),
          content: Text(message),
          //buttons?
          actions: <Widget>[
            TextButton(
              child: Text(negativeButton),
              onPressed: () {
                negativeCallBack();
              }, //closes popup
            ),
            TextButton(
              child: Text(positiveButton),
              onPressed: () {
                positiveCallBack();
              }, //closes popup
            )
          ],
        ));
  }

  static void showGetXNotificaitonPopUp(String title, String message) {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text(
            title,
          ),
          content: Text(message),
          //buttons?
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Get.back();
              }, //closes popup
            ),
          ],
        ));
  }

  static void showGetXPop(String title, String message) {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text(
            title,
          ),
          content: Text(message),
          //buttons?
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Get.toNamed(homePage);
              }, //closes popup
            ),
          ],
        ));
  }

  static void showGetXError(String msg) {
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        // The background color
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Error'), Text(msg)],
          ),
        ),
      ),
    );
  }

  static void showGetXErrorPopup(String title, String msg) {
    Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text(
            title,
          ),
          content: Text(msg),
          //buttons?
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Get.back();
              }, //closes popup
            ),
          ],
        ));
  }

  static void hideGetXLoading() {
    if (Get.isDialogOpen != null) {
      if (Get.isDialogOpen!) {
        Get.back();
      }
    }
  }

  static void showErrorSnackbar(String? message) {
    String errorMessage = message ??= "There was an error";
    Get.snackbar(
      "Error",
      errorMessage,
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showConfirmationDialog(
      BuildContext context, String title, String msg, Function() callback) {
    showDialog(
      context: context,
      builder: (BuildContext context2) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                // Close the dialog first
                Navigator.pop(context);
                callback();
              },
            ),
          ],
        );
      },
    );
  }

  static void showReviewPopup(BuildContext context, String name, String to,
      String? requestId, Function(ReviewModel) callback) {
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(.1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(child: Container()),
                Material(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Column(children: [
                      const SizedBox(height: 5),
                      const Text(
                        "Review!",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 32),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Please review $name",
                        style: const TextStyle(color: Color(0xffC0BFBD)),
                      ),
                      const SizedBox(height: 5),
                      RatingWidget(
                        requestId: requestId,
                        to: to,
                        callback: (review) {
                          showConfirmationDialog(context, "Thank you!",
                              "Successfully reviewed $name", () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            callback(review);
                          });
                        },
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
