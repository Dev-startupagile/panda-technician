// ignore_for_file: depend_on_referenced_packages, prefer_interpolation_to_compose_strings, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:panda_technician/app/modules/job_offer/job_offer.controller.dart';
import 'package:panda_technician/app/service/app_auth_service.dart';
import 'package:panda_technician/app/service/app_setting_service.dart';
import 'package:panda_technician/components/loading.dart';
import 'package:panda_technician/components/globalComponents/popUpMessage.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/core/constants/constants.dart';
import 'package:panda_technician/helper/dialog_helper.dart';
import 'package:panda_technician/models/bankInfo.dart';
import 'package:panda_technician/models/globalModels/schedule.dart';
import 'package:panda_technician/models/offer.dart';
import 'package:panda_technician/models/offer/RejectedOffers.dart';
import 'package:panda_technician/models/offer/SentOffer.dart';
import 'package:panda_technician/models/profile.dart';
import 'package:panda_technician/models/requests/canceld.dart';
import 'package:panda_technician/models/requests/detailedRequest.dart';
import 'package:panda_technician/models/requests/detailedRequestM.dart';
import 'package:panda_technician/models/auth/signUp.dart';
import 'package:panda_technician/models/service/service.dart';
import 'package:panda_technician/models/vehicle/vehicle.dart';
import 'package:panda_technician/routes/route.dart';
import 'package:panda_technician/store/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AvaliableSocialLogin { google, facebook, apple }

class ApiHandler {
  AppSettingService _appSettingService = Get.find<AppSettingService>();
  JobOfferController _jobOfferController = Get.find<JobOfferController>();
  AppAuthService _appAuthService = Get.find<AppAuthService>();
  Future<List<BankInfo>> getBankDetail() async {
    try {
      var url = Uri.parse(
          _appSettingService.config.baseURL + "/account/getBankAccount");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("Bank shit: " + response.body);
      List<BankInfo> bankInfo =
          bankInfoFromJson(json.encode(json.decode(response.body)['Items']));
      return bankInfo;
    } catch (e) {}
    return [];
  }

  Future<bool> isOfferAccepted(String requesetId) async {
    try {
      print("Is Accepted ");

      var url = Uri.parse(_appSettingService.config.baseURL +
          "/offerEstimation/byRquest/$requesetId");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("Is Accepted " + response.body);

      if (json.decode(response.body)["data"].length == 0) {
        return false;
      } else if (json.decode(response.body)["data"].length > 0) {
        bool respon = json.decode(response.body)["data"][0]["isApproved"];
        return respon;
        print("RRR: " + respon.toString());
      }
      // List<BankInfo> bankInfo = bankInfoFromJson(json.encode(json.decode(response.body)['Items']));
// return bankInfo;
    } catch (e) {}
// return [];
    return false;
  }

  Future<List<SentOffer>> isOfferCreated(String requesetId) async {
    try {
      print("Is Acceptedzz: " + requesetId);

      var url = Uri.parse(_appSettingService.config.baseURL +
          "/offerEstimation/byRquest/$requesetId");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("Is Accepted " + response.body);
      List<SentOffer> offer =
          sentOfferFromJson(json.encode(json.decode(response.body)["data"]));
      return offer;

      // List<BankInfo> bankInfo = bankInfoFromJson(json.encode(json.decode(response.body)['Items']));
// return bankInfo;
    } catch (e) {
      print("EEEEEEd: " + e.toString());
    }
// return [];
    return [];
  }

  Future<List<Canceld>?> getCanceldRequest() async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL +
          "/canceledByTechnician/byTechnicianId");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      // if(response.statusCode == 200){
      print("iiiiiiiiiiiiiiiiiiiiiii: " + response.body.toString());
      List<Canceld> _model =
          canceldFromJson(json.encode(json.decode(response.body)["Items"]));

      return _model;
      // }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 184");
      log(e.toString());
    }
    return null;
  }

  Future<int> getOfferCount() async {
    try {
      var url =
          Uri.parse(_appSettingService.config.baseURL + "/request/offers");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      // if(response.statusCode == 200){

      // List<ServiceRequestModel> _model = ServiceRequestModelFromJson(json.encode(json.decode(response.body)["data"])) as List<ServiceRequestModel>;

      return json.decode(response.body)["Count"];
      // }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 211");
      log(e.toString());
    }
    return 0;
  }

  Future<int> getSpecificOfferCount() async {
    try {
      var url = Uri.parse(
          _appSettingService.config.baseURL + "/request/technician/count");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );
      // if(response.statusCode == 200){

      // List<ServiceRequestModel> _model = ServiceRequestModelFromJson(json.encode(json.decode(response.body)["data"])) as List<ServiceRequestModel>;

      return json.decode(response.body)["Count"];
      // }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 237");
      log(e.toString());
    }
    return 0;
  }

  Future<ProfileModel> getProfile() async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL + "/auth/profile");
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("ABCD: " + response.body);
      ProfileModel _model = profileModelFromJson(json
          .encode(json.decode(response.body)["data"]["personalInformation"]));

      return _model;
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 304");
    }
    return ProfileModel(createdAt: DateTime.now(), updatedAt: DateTime.now());
  }

  deleteAccount(String email, context) async {
    try {
      var url = Uri.parse(
          "${_appSettingService.config.baseURL}/auth/removeUser/$email");

      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.delete(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        DialogBox(
            context, "Message", "Account deleted successfully", "Cancel", "Ok",
            (() async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove("apiToken");
          Get.toNamed(loginPage);
        }), (() async {
          final prefs = await SharedPreferences.getInstance();
          prefs.remove("apiToken");
          Get.toNamed(loginPage);
        }));
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 340");
    }
  }

  Future<Service> getService(String serviceId) async {
    try {
      var url =
          Uri.parse("${_appSettingService.config.baseURL}/service/$serviceId");

      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      Service service =
          serviceFromJson(json.encode(json.decode(response.body)["data"]));

      return service;
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 365");
    }

    return Service(
        createdAt: DateTime.now(),
        description: "",
        id: "",
        updatedAt: DateTime.now(),
        title: "") as Future<Service>;
  }

  Future<Vehicle> getVehicle(String vehicleId) async {
    try {
      var url =
          Uri.parse("${_appSettingService.config.baseURL}/vehicle/$vehicleId");

      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      Vehicle vehicle =
          vehicleFromJson(json.encode(json.decode(response.body)["data"]));

      return vehicle;
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 397");
    }

    return Vehicle(createdAt: DateTime.now(), updatedAt: DateTime.now())
        as Future<Vehicle>;
  }

  updateJobStatus(String requestId, context, String newStatus,
      Function updateStatus) async {
    try {
      //TODO: change to appsync
      var url =
          Uri.parse("${_appSettingService.config.baseURL}/request/$requestId");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"requestStatus": newStatus}));
      if (response.statusCode == 200) {
        Get.back();

        updateStatus();
      } else {
        showPurchaseDialog(context, "Error", "Somthing Went Wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 430");
    }
  }

  cancelJob(String requestId, context, Function cancelUpdateUI) async {
    try {
      var url =
          Uri.parse("${_appSettingService.config.baseURL}/request/$requestId");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"requestStatus": "CANCELED"}));

      if (response.statusCode == 200) {
        Get.back();
        Get.back();
        showPurchaseDialog(context, "Success", "Offer removed Successfully",
            isApiCall: false);

        cancelUpdateUI();
      } else {
        showPurchaseDialog(context, "Error", "Somthing Went Wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 462");
    }
  }

  openStartedJob(String requestId, context) async {
    try {
      var url =
          Uri.parse("${_appSettingService.config.baseURL}/request/$requestId");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

//detailedRequestDetailFromJson
      DetailedRequestM detailedRequest =
          DetailedRequestM.fromMap(json.decode(response.body)["data"]);

      if (response.statusCode == 200) {
        Vehicle vehicles =
            await ApiHandler().getVehicle(detailedRequest.vehicleId[0]);
        Service service =
            await ApiHandler().getService(detailedRequest.serviceId);

        Get.back();
        Get.toNamed(jobDetail,
            arguments: DetailedRequest(
                request: detailedRequest,
                vehicle: vehicles,
                service: service,
                estimation: Offer(items: [])));
      } else {
        showPurchaseDialog(context, "Error", "Somthing Went Wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 627");
    }
  }

  changePassword(String currentPassword, String newPassword, context) async {
    try {
      var url =
          Uri.parse(_appSettingService.config.baseURL + "/auth/changePassword");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "currentPassword": currentPassword,
            "newPassword": newPassword
          }));
      if (response.statusCode == 201) {
        Get.back();

        showPurchaseDialog(context, "Success", "Password Changed Successfully",
            isApiCall: true);
      } else {
        Get.back();

        showPurchaseDialog(
            context, "Error", json.decode(response.body)["message"],
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 662");
    }
  }

  resetPassword(String email, String newPassword, String otp) async {
    try {
      var url =
          Uri.parse(_appSettingService.config.baseURL + "/auth/resetPassword");
      var response = await http.patch(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email.toLowerCase(),
            "newPassword": newPassword,
            "otp": int.parse(otp)
          })

          // })
          );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 687");
    }
  }

  sendSupportEmail(String email, String message, context) async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL + "/contactUs/");
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
              {"from": email, "subject": "Support Needed", "message": message})

          // })
          );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        // DialogBox(context, title, message, negativeButton, positiveButton, negativeCallBack, positiveCallBack)
        DialogBox(context, "Success", "Email sent to Support successfully",
            "Cancel", "Ok", (() {
          Get.back();
        }), (() {
          Get.back();
        }));
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 723");
    }
  }

  sendRating(String to, double rating, String requestId, String feedback,
      context) async {
    print("YMCA: " +
        jsonEncode({
          "rating": rating,
          "to": to,
          "requestId": requestId,
          "feedback": feedback
        }));
    try {
      var url = Uri.parse(_appSettingService.config.baseURL + "/rating/send");
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "rating": rating,
            "to": to,
            "requestId": requestId,
            "feedback": feedback
          })

          // })
          );

      print("StutsCode: " + response.statusCode.toString());
      print("body: " + response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        // DialogBox(context, title, message, negativeButton, positiveButton, negativeCallBack, positiveCallBack)
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 768");
      return true;
    }
  }

  changeStatus(double latitude, double longitude, bool status, context,
      Function(bool) callBack) async {
    try {
      var url = Uri.parse(
          _appSettingService.config.baseURL + "/users/technician/status");
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "latitude": latitude,
            "longitude": longitude,
            "isOnline": status
          }));

      print("RRE: " +
          jsonEncode({
            "latitude": latitude,
            "longitude": longitude,
            "isOnline": status
          }));
      print("RES: " + response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Provider.of<StateProvider>(context,listen: false).changeTechnicianState(status);

        // Timer(Duration(seconds: 4), () {
        callBack(jsonDecode(response.body)["data"]["isOnline"]);
// });
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 813");
    }
  }

  sendOtp(String email, context) async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL + "/auth/sendOTP");
      var response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email.toLowerCase(),
          })

          // })
          );
      print("AAKDK: " + response.statusCode.toString());
      print("BBNEN: " + response.body);

      if (response.statusCode == 200) {
        if (json.decode(response.body)["code"] == 400) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 842");
    }
  }

  autoComplete(street) async {
    var apiKey = dotenv.env["GOOGLE_API"];
    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$street&key=$apiKey"));

    return response.body;
  }

  getLocationName(double lat, double lng) async {
    var apiKey = dotenv.env["GOOGLE_API"];
    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey"));
    return response.body;
    //results[0]["formatted_address"]
  }

  Future<bool> signInWithSocial(
      bool signIn, AvaliableSocialLogin socialLogin) async {
    DialogHelper.showGetXLoading();

    try {
      AuthProvider authProvider = socialLogin == AvaliableSocialLogin.google
          ? AuthProvider.google
          : socialLogin == AvaliableSocialLogin.facebook
              ? AuthProvider.facebook
              : AuthProvider.apple;
      print("Signed in with $socialLogin");
      SignInResult res =
          await Amplify.Auth.signInWithWebUI(provider: authProvider);
      print("Sign in result ${res.isSignedIn}");
      DialogHelper.hideGetXLoading();
      if (res.isSignedIn) {
        List<AuthUserAttribute> listOfAttr =
            await Amplify.Auth.fetchUserAttributes();
        String email = listOfAttr
            .firstWhere((element) => element.userAttributeKey.key == "email")
            .value;
        // AuthSession session = await Amplify.Auth.fetchAuthSession();

        // ac.JsonWebToken token = (session as ac.CognitoAuthSession)
        //     .userPoolTokensResult
        //     .value
        //     .accessToken;
        // print("JWT Token: $token");
        print("User's email: $email");
        // Send email and JWT token to backend
        // ignore: use_build_context_synchronously

        if (signIn) {
          bool result = await login(email, AppConstants.kDefaultPassword);
          if (!result) {
            DialogHelper.showGetXErrorPopup("Login Error:",
                "Please sign-up first or try to login via Email and Password");
          }
        } else {
          Get.toNamed("CreateAccount",
              arguments: new SignUp(
                  email: email, password: AppConstants.kDefaultPassword));
          return true;
        }
      }
    } catch (e) {
      print("Error getting user data: $e");
      DialogHelper.hideGetXLoading();
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      String fcmToken = "";
      final prefs = await SharedPreferences.getInstance();

      fcmToken = prefs.getString("fcmToken").toString();
      print("AKL: " + fcmToken);
      var url = Uri.parse(_appSettingService.config.baseURL + "/auth/login");
      var response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email.toLowerCase(),
            "password": password,
            "userRole": "technician",
            "fcm_token": fcmToken
          })
          // })
          );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        prefs.setString("apiToken", data["token"]);
        _appAuthService.signin(data["data"], data["token"]);
        //INFO: Start listening for job request
        _jobOfferController.listenForRequestUpdate();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
    }
    return false;
  }

  verifyAccount(String email, String verificationCode) async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL + "/auth/verify");
      var response = await http.post(url,
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode({
            "email": email.toLowerCase(),
            "code": int.parse(verificationCode)
          })
          // })
          );

      print("iiiiiiiii: " + response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        print("jjjjjjjjjjj: " + json.decode(response.body)["token"]);
        prefs.setString("apiToken", json.decode(response.body)["token"]);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 928");
      return false;
    }
  }

  Future<List<RejectedOffer>?> getMyEstimation(String email) async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL +
          "/offerEstimation/bySender/" +
          email);
      final prefs = await SharedPreferences.getInstance();

      var token = prefs.getString("apiToken");

      var response = await http.get(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      print("EstimationList: " + response.body);
      List<RejectedOffer> rejectedOffer = RejectedOfferFromJson(response.body);

      return rejectedOffer;
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 953");
    }
  }

  sendOffer(Offer offer, context, DetailedRequest detailed) async {
    try {
      var url = Uri.parse(
          "${_appSettingService.config.baseURL}/offerEstimation/send");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(offer.toJson()));

      if (response.statusCode == 201) {
        Get.toNamed(jobDetail, arguments: detailed);
      } else {
        showPurchaseDialog(context, "Error", "Something went wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 980");
    }
  }

  updateOffer(Offer offer, context, DetailedRequest detailed) async {
    try {
      print("asdfsdf " + offer.id);
      var url = Uri.parse(
          "${_appSettingService.config.baseURL}/offerEstimation/${offer.id}");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(offer.toJson()));

      print("UUU: " + response.body);
      if (response.statusCode == 200) {
        DialogBox(context, "Success", "Updated Successfully", "Cancel", "Ok",
            (() {
          Get.toNamed(jobDetail, arguments: detailed);
        }), (() {
          Get.toNamed(jobDetail, arguments: detailed);
        }));
      } else {
        showPurchaseDialog(context, "Error", "Something went wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1014");
    }
  }

  updateProfile(SignUp profile, context, email) async {
    try {
      var url = Uri.parse("${_appSettingService.config.baseURL}/users/$email");

      print("UIUIUI: " + json.encode(profile));

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(profile.toJson()));

      if (response.statusCode == 200) {
        ProfileModel profileDetail = await ApiHandler().getProfile();
        Provider.of<ProfileProvider>(context, listen: false)
            .changeProfileProvider(profileDetail);

        DialogBox(context, "Success", "Updated", "Cancel", "Ok", (() {
          Get.offAndToNamed(profilePage);
        }), (() {
          Get.offAndToNamed(profilePage);
        }));
      } else {
        showPurchaseDialog(context, "Error", "Something went wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1051");
    }
  }

  createAccount(SignUp requestBody, context) async {
    try {
      String fcmToken = "";
      FirebaseMessaging.instance.getToken().then((token) async {
        print("MY TOKEN: " + token.toString());
        fcmToken = token.toString();
        requestBody.fcm_token = fcmToken;
        // requestBody.phoneNumber = formatPhoneNumber(requestBody.phoneNumber);
        requestBody.phoneNumber = requestBody.phoneNumber;
        print("AKA :" + requestBody.phoneNumber);
        print("BODY: " + json.encode(requestBody));

        var url = Uri.parse(_appSettingService.config.baseURL + "/auth/signup");
        var response = await http.post(url,
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode(requestBody.toJson())
            // })
            );

        print(response.body);
        print("AHAHAHA: " + response.statusCode.toString());

        if (response.statusCode == 201) {
          final prefs = await SharedPreferences.getInstance();
          if (json.decode(response.body)["success"]) {
// prefs.setString("apiToken", json.decode(response.body)["token"]);
            prefs.setString("userId", json.decode(response.body)["userID"]);
            prefs.setString("userEmail", requestBody.email);

            Get.offAndToNamed(signup);
          } else {
            //todo: error message add here
          }
        } else {
          if (response.statusCode == 500) {
            showPurchaseDialog(
                context, "Error Occured", "Something Went Wrong");
          } else {
            showPurchaseDialog(
                context, "Error Occured", json.decode(response.body)["data"]);
          }
        }
      });
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1099");
    }
  }

  fileUpload(String filePath) async {
    try {
      var url = Uri.parse(_appSettingService.config.baseURL + "/files/images");
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      Future<http.MultipartFile> httpImage =
          http.MultipartFile.fromPath('image', filePath, filename: 'myImage');
      request.files.add(await httpImage);

      var response = await request.send();

      return response.stream.bytesToString();
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1119");
    }
  }

  w9Upload(String filePath) async {
    try {
      var url =
          Uri.parse(_appSettingService.config.baseURL + "/files/documents");
      var request = http.MultipartRequest(
        'POST',
        url,
      );
      Future<http.MultipartFile> httpImage =
          http.MultipartFile.fromPath('document', filePath, filename: 'myw9');
      request.files.add(await httpImage);

      var response = await request.send();

      return response.stream.bytesToString();
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1139");
    }
  }

  void addBankInfo(String w9uri, String bankName, String accountNumber,
      String routingNumber, context) async {
    try {
      var url = Uri.parse(
          _appSettingService.config.baseURL + "/account/addBankAccount/");
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "w9": w9uri,
            "routingNumber": routingNumber,
            "bankName": bankName,
            "accNumber": accountNumber,
          })

          // })
          );

      print("BODY : " +
          jsonEncode({
            "w9": w9uri,
            "routingNumber": routingNumber,
            "bankName": bankName,
            "accNumber": accountNumber,
            "message": "bank info"
          }));
      print("KKKKK: " + response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        // DialogBox(context, title, message, negativeButton, positiveButton, negativeCallBack, positiveCallBack)
        DialogBox(context, "Success", "Bank Information Added Successfully",
            "Cancel", "Ok", (() {
          Get.back();
          Get.offAndToNamed(profilePage);
        }), (() {
          Get.back();
          Get.offAndToNamed(profilePage);
        }));
      } else {}
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1190");
    }
  }

  reschedule(Schedule schedule, String requestId, context) async {
    try {
      var url =
          Uri.parse("${_appSettingService.config.baseURL}/request/$requestId");

      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "schedule": schedule.toJson(),
            "isScheduled": true,
          }));

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        DialogBox(context, "Message", "Request Is Rescheduled", "cancel", "ok",
            (() {
          Get.toNamed(requests);
        }), (() {
          Get.toNamed(requests);
        }));
      } else {
        showPurchaseDialog(context, "Error", "Something went wrong",
            isApiCall: true);
      }
    } catch (e) {
      print("EE: " + e.toString());
    }
  }

  void updateBankInfo(String wwwi, String bankName, String accountNumber,
      String routingNumber, BuildContext context) async {
    try {
      var url = Uri.parse(
          _appSettingService.config.baseURL + "/account/updateBankAccount/");
      final prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("apiToken");

      Loading(context);
      var response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            "w9": wwwi,
            "routingNumber": routingNumber,
            "bankName": bankName,
            "accNumber": accountNumber,
          })

          // })
          );
      print("UUUU: " +
          jsonEncode({
            "w9": wwwi,
            "routingNumber": routingNumber,
            "bankName": bankName,
            "accNumber": accountNumber,
          }));
      print("EEEEEE: " + response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.back();
        // DialogBox(context, title, message, negativeButton, positiveButton, negativeCallBack, positiveCallBack)
        DialogBox(context, "Success", "Bank Information Updated Successfully",
            "Cancel", "Ok", (() {
          Get.back();
          Get.back();
          Get.offAndToNamed(profilePage);
        }), (() {
          Get.back();
          Get.offAndToNamed(profilePage);
        }));
      } else {
        Get.back();
        DialogBox(context, "Error", "Something went wrong", "Cancel", "Ok",
            (() {
          Get.back();
        }), (() {
          Get.back();
        }));
      }
    } catch (e) {
      print("Error: " + e.toString());
      print("Line: 1329");
    }
  }
}
