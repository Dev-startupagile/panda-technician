import 'package:get/get.dart';
import 'package:panda_technician/app/modules/job_offer/job_offer.controller.dart';
import 'package:panda_technician/app/service/app_amplify_service.dart';
import 'package:panda_technician/app/service/app_api_service.dart';
import 'package:panda_technician/app/service/app_auth_service.dart';
import 'package:panda_technician/app/service/app_logger.dart';
import 'package:panda_technician/app/service/app_rating_service.dart';
import 'package:panda_technician/app/service/app_setting_service.dart';
import 'package:panda_technician/app/service/app_storage_service.dart';
import 'package:panda_technician/services/fcmService.dart';

Future<void> initAppService() async {
  //App FCM Notificaiton
  await FCMService.init();

  await PandaAmplify.configureAmplify();

  Get.put<AppLoggerService>(AppLoggerService());

  var appStorageService = AppStorageService();
  await appStorageService.init();

  Get.put<AppStorageService>(appStorageService);

  //App setting service

  var appSettingService = AppSettingService();
  await appSettingService.init();

  Get.put<AppSettingService>(appSettingService);

  //App Auth service
  AppAuthService appAuthService = AppAuthService();
  await appAuthService.init();
  Get.put<AppAuthService>(appAuthService);

  //App API service

  var appAPIService = AppApiService();
  Get.put<AppApiService>(appAPIService);

  Get.put<RatingReviewService>(RatingReviewService());

  // appAuthService.setRepository(AppAuthRepository());
  // FlutterNativeSplash.remove();

  Get.put<JobOfferController>(JobOfferController());
}
