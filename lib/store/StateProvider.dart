// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/app/service/app_auth_service.dart';

class StateProvider with ChangeNotifier {
  bool active = false;
  AppAuthService _appAuthService = Get.find<AppAuthService>();

  StateProvider({this.active = false});

  void changeTechnicianState(bool newState) {
    active = newState;
    notifyListeners();
  }
}
