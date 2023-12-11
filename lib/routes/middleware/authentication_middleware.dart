import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/app/service/app_auth_service.dart';
import 'package:panda_technician/routes/route.dart';

class AuthMiddleware extends GetMiddleware {
  final AppAuthService appAuthService = Get.find<AppAuthService>();
  @override
  int? get priority => 1;
  bool isAuthenticated = false;

  @override
  RouteSettings? redirect(String? route) {
    if (appAuthService.user != null) {
      return const RouteSettings(name: homePage);
    }
    return null;
  }
}
