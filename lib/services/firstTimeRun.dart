import 'package:get/get.dart';
import 'package:panda_technician/app/service/app_auth_service.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/routes/route.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

setFirstTimeLoad() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("FirstTimeLoad", true);
}

checkFirstTimeLoad(context, Function checked) async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getKeys().contains("FirstTimeLoad")) {
    Get.toNamed(loginPage);
  } else {
    checked();
  }
}

logout(context) async {
  DialogBox(context, "Message", "Are you sure you want to logout", "No", "Yes",
      (() {
    Get.back();
  }), (() async {
    final AppAuthService appAuthService = Get.find<AppAuthService>();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("apiToken");
    await appAuthService.logout();
// prefs.remove("tutorialSession");
    Get.offAndToNamed(loginPage);
  }));
}


// logout(context) async{
  
// DialogBox(context, "Message", "Are you sure you want to logout", "No", "Yes", ((){
// Get.back();
// }), (()async{
//   final prefs = await SharedPreferences.getInstance();
// prefs.remove("apiToken");
// Get.toNamed("Login");

// }));
// }
