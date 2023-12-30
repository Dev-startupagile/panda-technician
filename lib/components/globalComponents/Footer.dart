// ignore_for_file: unused_import, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/helper/dialog_helper.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/screens/requests/MapScreen.dart';
import 'package:panda_technician/store/StateProvider.dart';
import 'package:provider/provider.dart';

class Footer extends StatefulWidget {
  Footer(
      {super.key,
      required this.screenIndex,
      required this.homeButton,
      required this.offerButton,
      required this.requestButton,
      required this.profileButton});
  int screenIndex = 0;
  Key homeButton;
  Key offerButton;
  Key requestButton;
  Key profileButton;
  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  void _navigateToScreen(index, context) {
    if (widget.screenIndex == 0) {
      if (index == 0) {
        Get.toNamed(homePage);
      } else if (index == 1) {
        Get.toNamed(offers);
      } else if (index == 2) {
        Get.toNamed(requests);
      } else if (index == 3) {
        Get.toNamed(profilePage);
      }
    } else {
      if (index == 0) {
        if (widget.screenIndex == 0) {
          Get.offAndToNamed(homePage);
        } else {
          Get.toNamed(homePage);
        }
      } else if (index == 1) {
        if (widget.screenIndex == 1) {
          Get.offAndToNamed(offers);
        } else {
          Get.toNamed(offers);
        }
      } else if (index == 2) {
        if (widget.screenIndex == 2) {
          Get.offAndToNamed(requests);
        } else {
          Get.toNamed(requests);
        }
      } else if (index == 3) {
        if (widget.screenIndex == 0) {
          Get.offAndToNamed(profilePage);
        } else {
          Get.toNamed(profilePage);
        }
      }
    }
  }

  late Timer timer;
  int notificationBaj = 0;
  int specificNotificationBaj = 0;
  @override
  void initState() {
    super.initState();
    updateNotificationBaj().then(showPendingRequestPopup);
    updateSpecificNotificationBaj();

    timer = Timer.periodic(
        Duration(seconds: 15), (Timer t) => updateNotificationBaj());
    timer = Timer.periodic(
        Duration(seconds: 15), (Timer t) => updateSpecificNotificationBaj());
  }

  FutureOr<dynamic> showPendingRequestPopup(_) {
    if (notificationBaj > 0) {
      DialogHelper.showGetXDialogBox(
          "Pending Service Request",
          "There is pending service request in your offers page.",
          "cancle",
          "view", () {
        Get.back();
      }, () {
        _navigateToScreen(1, context);
      });
    }
  }

  Future<void> updateNotificationBaj() async {
    notificationBaj = await ApiHandler().getOfferCount();

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  updateSpecificNotificationBaj() async {
    specificNotificationBaj = await ApiHandler().getSpecificOfferCount();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  bool isActive(context) {
    return Provider.of<StateProvider>(context).active;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 60,
        child: BottomNavigationBar(
          onTap: (index) {
            _navigateToScreen(index, context);
          },
          elevation: 5,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(key: widget.homeButton, Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: <Widget>[
                  Icon(key: widget.offerButton, Icons.request_page),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: (notificationBaj == 0)
                            ? Colors.transparent
                            : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 17,
                        minHeight: 17,
                      ),
                      child: Text(
                        notificationBaj.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(key: widget.requestButton, Icons.data_exploration),
              label: 'Requests',
            ),
            //            BottomNavigationBarItem(
            //           icon:  Stack(

            //   children: <Widget>[
            //      const Icon(Icons.notifications),
            //      Positioned(
            //       right: 0,
            //       top: 0,
            //       child: Container(
            //         padding: const EdgeInsets.all(1),
            //         decoration: BoxDecoration(
            //           color:(specificNotificationBaj ==0)? Colors.transparent: Colors.red,
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         constraints: const BoxConstraints(
            //           minWidth: 14,
            //           minHeight: 14,
            //         ),
            //         child:  Text(
            //           specificNotificationBaj.toString(),
            //           style:  TextStyle(
            //             color: Colors.white,
            //             fontSize: 8,
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            //           label: 'Notification',
            //         ),
            BottomNavigationBarItem(
              icon: Icon(key: widget.profileButton, Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: widget.screenIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Color.fromARGB(255, 114, 114, 114),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14),
        ));
  }
}
