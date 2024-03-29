// ignore_for_file: sort_child_properties_last, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/app/modal/auto_service/service_request_model.dart';
import 'package:panda_technician/app/modules/job_offer/job_offer.controller.dart';
import 'package:panda_technician/app/service/app_auth_service.dart';
import 'package:panda_technician/app/service/app_setting_service.dart';
import 'package:panda_technician/app/service/stripe_service.dart';
import 'package:panda_technician/components/globalComponents/Footer.dart';
import 'package:panda_technician/components/loading.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/components/offerComponents/SpecificSingleOfferCard.dart';
import 'package:panda_technician/core/exceptions/app_exception_interface.dart';
import 'package:panda_technician/core/exceptions/app_http_exceptions.dart';
import 'package:panda_technician/helper/dialog_helper.dart';
import 'package:panda_technician/models/profile.dart';
import 'package:panda_technician/models/requests/canceld.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/screens/profile/stripeWebview.dart';
import 'package:panda_technician/services/appStateService.dart';
import 'package:panda_technician/services/serviceDate.dart';
import 'package:panda_technician/services/serviceLocation.dart';
import 'package:panda_technician/services/tutorialService.dart';
import 'package:panda_technician/store/StateProvider.dart';
import 'package:panda_technician/store/profileProvider.dart';
import 'googleMap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:provider/provider.dart';
import 'package:panda_technician/components/messageComponents/centredMessage.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  var profileDetail =
      ProfileModel(createdAt: DateTime.now(), updatedAt: DateTime.now());
  int notificationBaj = 0;
  late Timer timer;
  bool locationFound = false;
  int updater = 0;
  List<int> canceldList = [];
  List<Canceld> canceld = [];
  int count = 0;
  int specificNotificationBaj = 0;
  AppAuthService _appAuthService = Get.find<AppAuthService>();
  List<TargetFocus> targets = [];

  LatLng myLocation = LatLng(343.43, 342.34);

  AppSettingService _appSettingService = Get.find<AppSettingService>();

  final GlobalKey toggle = GlobalKey();
  final GlobalKey homeButton = GlobalKey();
  final GlobalKey offerButton = GlobalKey();
  final GlobalKey notification = GlobalKey();
  final GlobalKey requestButton = GlobalKey();
  final GlobalKey profileButton = GlobalKey();
  final GlobalKey myLocationButton = GlobalKey();

  final StripeService _stripeService = StripeService();
  bool bottomSheetShown = false;
  int oldRequestCount = 0;

  final JobOfferController jobOfferController = Get.find<JobOfferController>();

  void gotoSetupPaymentPage() async {
    try {
      // Get.toNamed("Payment");
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");
      Loading(context);
      var response = await http.get(
        Uri.parse(
            '${_appSettingService.config.baseURL}/account/connectAccountLink'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );

      // setState(() {
      //   strapiToken = json.decode(response.body)["url"] ?? "empty";
      // });

      var authUrl = json.decode(response.body)["url"] ?? "empty";

      if (authUrl == "empty") {
        Get.back();
        DialogBox(context, "Message", "Already Connected", "Cancel", "Ok", (() {
          Get.back();
        }), (() {
          Get.back();
        }));
      } else {
        Get.back();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => StripeWebView(
                      stripeUrl: Uri.parse(authUrl),
                    )));
      }
    } catch (e) {
      DialogBox(context, "Message",
          "Error Occured when trying to connect account!", "Cancel", "Ok", (() {
        Get.back();
      }), (() {
        Get.back();
      }));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<ProfileProvider>(context, listen: false).profile.id ==
          "") {
        Provider.of<ProfileProvider>(context, listen: false)
            .changeProfileProvider(profileDetail);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //INFO: Start listening for job request
    jobOfferController.listenForRequestUpdate();

    profileDetail =
        ProfileModel(createdAt: DateTime.now(), updatedAt: DateTime.now());
    jobOfferController.requestStreamController.stream.listen((event) {
      print("[MapScreen requestStreamController]$event");
      var serviceRequests = jobOfferController.serviceRequests
          .where((s) => s.requestStatus == 'PENDING')
          .toList();
      if (serviceRequests.isNotEmpty)
        _showNewRequestButtonSheet(serviceRequests);
      updateSpecificNotificationBaj();
    });

    getProfiles();
    getMyLocation();

    WidgetsBinding.instance.addObserver(LifecycleEventHandler(
        detachedCallBack: () => (() async {
              await ApiHandler().changeStatus(
                  0,
                  0,
                  !Provider.of<StateProvider>(context, listen: true).active,
                  context, ((value) {
                Provider.of<StateProvider>(context, listen: false)
                    .changeTechnicianState(value);
              }));
            }),
        resumeCallBack: () async {
          print('resume...');
        }));

    targets.add(
      TargetFocus(
          identify: "Logo toggle",
          keyTarget: toggle,
          paddingFocus: 0,
          contents: [
            TargetContent(
                child: Text(
                    "Press This Icon to Activate or Deactivate Your Status",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );
    targets.add(
      TargetFocus(identify: "Notification", keyTarget: notification, contents: [
        TargetContent(
            child: Text(
                "Request sent to you will be shown in the notification screen",
                style: TextStyle(fontWeight: FontWeight.bold)))
      ]),
    );

    targets.add(
      TargetFocus(
          identify: "MyLocation",
          keyTarget: myLocationButton,
          contents: [
            TargetContent(
                child: Text("Use this button to find your location",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );
    targets.add(
      TargetFocus(
          identify: "Home",
          keyTarget: homeButton,
          targetPosition: TargetPosition(Size(100, 100), Offset(34, -50)),
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Text(
                    "Home Button Shows a map where you can see where your customers are",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );

    targets.add(
      TargetFocus(
          identify: "OfferButton",
          keyTarget: offerButton,
          targetPosition: TargetPosition(Size(100, 100), Offset(34, -50)),
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Text(
                    "List of offers that are not assigned to you are found here",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );

    targets.add(
      TargetFocus(
          identify: "requestButton",
          keyTarget: requestButton,
          targetPosition: TargetPosition(Size(100, 100), Offset(34, -50)),
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Text(
                    "Requests that you have Accepted,Cancelled and Completed are found here",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );
    targets.add(
      TargetFocus(
          identify: "profile",
          keyTarget: profileButton,
          targetPosition: TargetPosition(Size(100, 100), Offset(34, -50)),
          contents: [
            TargetContent(
                align: ContentAlign.top,
                child: Text(
                    "You can edit and update your profile info with in this screen",
                    style: TextStyle(fontWeight: FontWeight.bold)))
          ]),
    );

    tutorialSession(targets, context);
  }

  tutorialSession(targets, context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getKeys().contains("tutorialSession")) {
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        showTutorial(targets, context);
      });

      prefs.setBool("tutorialSession", true);
    }
  }

  // getSpecificJobs

  updateSpecificNotificationBaj() async {
    specificNotificationBaj = await ApiHandler().getSpecificOfferCount();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  getMyLocation() async {
    permissionWithCallback(context, (() async {
      Position posi = await getLocation();
      setState(() {
        myLocation = LatLng(posi.latitude, posi.longitude);
        locationFound = true;
      });
    }));

    //           Position posi = await getLocation();
    //           setState(() {
    // _center = LatLng(posi.latitude, posi.longitude);
    //             locationFound = true;
    //           });
  }

  void _showNewRequestButtonSheet(
      List<ServiceRequestModel> serviceRequests) async {
    //TODO: replace this
    // canceld = (await ApiHandler().getCanceldRequest())!;

    showModalBottomSheet(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              height: 300,
              decoration: BoxDecoration(color: Colors.transparent),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(4),
              child: ListView.builder(
                  itemCount: serviceRequests.length,
                  itemBuilder: (context, index) {
                    return SpecificSingleOfferCard(
                        time:
                            changeToAmPm(serviceRequests[index].schedule.time),
                        date: getUsDateFormat(
                            serviceRequests[index].schedule.date),
                        requestId: serviceRequests[index].id,
                        request: serviceRequests[index],
                        cancelOffer: (() {
                          setState(() {
                            canceldList.add(index);
                          });
                        }));
                  }));
        });
  }

  updateNotificationBaj() async {
    notificationBaj = await ApiHandler().getOfferCount();
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void getProfiles() async {
    try {
      profileDetail = (await ApiHandler().getProfile());
      Provider.of<StateProvider>(context, listen: false)
          .changeTechnicianState(profileDetail.isOnline);
      Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
            profileDetail = profileDetail;
          }));
    } on UnauthorizedException catch (_) {
      DialogHelper.showErrorConfirmationDialog(
          context, "Session Expired", "You will be logged out now.", () async {
        _appAuthService.logout();
        Get.offNamedUntil(loginPage, (route) => route.isFirst);
      });
    } on AppException catch (_) {
      DialogHelper.showGetXErrorPopup(
          "Something went wrong", "Something went wrong. please try again.");
    } catch (_) {
      DialogHelper.showGetXErrorPopup(
        "Connectivity Issue",
        "Network connectivity issue. please check your Internet connection.",
      );
    }
  }

  Future<bool> isAccountNotConnected() async {
    try {
      var response = await _stripeService.stripeRetrieveAccount();
      return response["details_submitted"] == null ||
          response["details_submitted"] == false;
    } catch (e) {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: true,
        child: WillPopScope(
            onWillPop: () async {
              DialogBox(
                  context,
                  "Logout message",
                  "Are you sure you want to go offline and close the app?",
                  "No",
                  "Yes", (() {
                Get.back();
              }), (() async {
                Loading(context);
                await ApiHandler().changeStatus(0.0, 0.0, false, context,
                    ((value) {
                  SystemNavigator.pop();
                }));
              }));
              return false;
            },
            child: Scaffold(
                floatingActionButton: SizedBox(
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Icon(
                        key: myLocationButton,
                        Icons.my_location,
                        color: Color.fromARGB(255, 97, 97, 97),
                      ),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          locationFound = false;
                        });
                        getMyLocation();
                      },
                    )),
                appBar:
                    // PreferredSize(
                    //     preferredSize: Size.fromHeight(70.0), // here the desired height
                    // child:
                    AppBar(
                  toolbarHeight: 70,
                  leading: Container(
                      key: toggle,
                      width: 40,
                      height: 40,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 10,
                            left: 10,
                            child: GestureDetector(
                                onTap: () async {
                                  bool isOnline = Provider.of<StateProvider>(
                                          context,
                                          listen: false)
                                      .active;
                                  Loading(context);

                                  handleLocationPermission(context);

                                  Position posi = await getLocation();

                                  bool isAccountConnectedValue =
                                      await isAccountNotConnected();
                                  if (isAccountConnectedValue && !isOnline) {
                                    Get.back();
                                    // Get.back();

                                    DialogHelper.showGetXDialogBox(
                                        "Account Setup Incomplete",
                                        "You need to connect your bank account before going online. Please navigate to your profile page to then payment to link your account.",
                                        "cancel",
                                        "Okay",
                                        () => Get.back(),
                                        gotoSetupPaymentPage);
                                    return;
                                  }
                                  await ApiHandler().changeStatus(
                                      posi.latitude,
                                      posi.longitude,
                                      !isOnline,
                                      context, ((value) {
                                    Get.back();
                                    Provider.of<StateProvider>(context,
                                            listen: false)
                                        .changeTechnicianState(value);
                                  }));

                                  // Get.offAndToNamed(homePage);
                                },
                                child: Image.asset(
                                  //  key: toggle,
                                  "assets/HeaderLogo.png", height: 40,
                                  width: 40,
                                )),
                          ),
                          Positioned(
                            width: 10,
                            height: 10,
                            right: 6,
                            bottom: 22,
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Provider.of<StateProvider>(context,
                                            listen: true)
                                        .active
                                    ? Colors.green
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      )),
                  actions: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 5.3, 0),
                        child: GestureDetector(
                          onTap: () async {
                            // handleLocationPermission(context);
                            //       Position posi =await  getLocation();
                            //     await ApiHandler().changeStatus(posi.latitude, posi.longitude,!stateNow, context);

                            // Provider.of<StateProvider>(context,listen: false).changeTechnicianState(!stateNow);
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(right: 5.35),
                              child: GestureDetector(
                                  onTap: () async {
                                    // handleLocationPermission(context);
                                    //       Position posi =await  getLocation();
                                    //     await ApiHandler().changeStatus(posi.latitude, posi.longitude,!stateNow, context);

                                    //       Provider.of<StateProvider>(context,listen: false).changeTechnicianState(!stateNow);

                                    Get.toNamed(notificationPage);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Stack(
                                        children: <Widget>[
                                          Icon(
                                            key: notification,
                                            Icons.notifications,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 5,
                                            child: Container(
                                              padding: const EdgeInsets.all(1),
                                              decoration: BoxDecoration(
                                                color:
                                                    (specificNotificationBaj ==
                                                            0)
                                                        ? Colors.transparent
                                                        : Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 14,
                                                minHeight: 14,
                                              ),
                                              child: Text(
                                                specificNotificationBaj
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          )
                                        ],
                                      ))

                                  //  Icon(
                                  // color: stateNow? Colors.green[400]  :Colors.grey[400] ,
                                  //  stateNow? Icons.toggle_on : Icons.toggle_off,
                                  //   size: 46.0,
                                  // ),
                                  )),
                        ))
                  ],
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Column(
                    children: [
                      Text(
                        "Panda Technician",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        Provider.of<StateProvider>(context, listen: true).active
                            ? "Online"
                            : "Offline",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Provider.of<StateProvider>(context,
                                        listen: true)
                                    .active
                                ? Colors.green[700]
                                : Colors.red[700]),
                      )
                    ],
                  ),
                ),
                body: locationFound
                    ? MapCard(
                        myLocation: this.myLocation,
                        locationFound: locationFound)
                    : CentredMessage(
                        messageWidget: Container(
                        width: 100.0,
                        height: 100.0,
                        margin: EdgeInsets.fromLTRB(0, 0, 10, 2),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/Loading.gif")),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.grey[300],
                        ),
                      )),
                bottomNavigationBar: Footer(
                  screenIndex: 0,
                  homeButton: homeButton,
                  offerButton: offerButton,
                  requestButton: requestButton,
                  profileButton: profileButton,
                ))));
  }
}
