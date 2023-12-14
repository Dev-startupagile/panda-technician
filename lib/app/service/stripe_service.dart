import 'package:get/get.dart';
import 'package:panda_technician/app/service/app_api_service.dart';

class StripeService extends GetxService {
  final AppApiService _appApiService = Get.find<AppApiService>();

  Future<Map<String, dynamic>> stripeRetrieveAccount() async {
    var response = await _appApiService
        .authPost('/account/get/connectedAccount', data: {});
    return response.data;
  }
}
