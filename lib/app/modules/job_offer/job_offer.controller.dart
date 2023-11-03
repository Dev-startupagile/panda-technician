import 'package:get/get.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/app/modules/base_controller.dart';
import 'package:panda_technician/app/repository/auto_service_repository.dart';
import 'package:panda_technician/helper/dialog_helper.dart';
import 'package:panda_technician/models/offer.dart';
import 'package:panda_technician/models/requests/detailedRequest.dart';
import 'package:panda_technician/models/requests/requests.dart';
import 'package:panda_technician/models/requests/viewDetailRequests.dart';
import 'package:panda_technician/models/service/service.dart';
import 'package:panda_technician/models/vehicle/vehicle.dart';
import 'package:panda_technician/screens/requests/StatusRequest.dart';

class JobOfferController extends BaseController {
  final AutoServiceRepository _repository = AutoServiceRepository();

  Future<void> rejectJob(
      String requestId, String technicianId, String customerId) async {
    try {
      showGetXLoading();
      await _repository.rejectJob(requestId, technicianId, customerId);
      hideGetXLoading();
      DialogHelper.showGetXDialogBox(
          "Success", "Successfully Rejected Job", "Cancel", "Ok", () {
        Get.offAndToNamed("Offers");
      }, () {
        Get.offAndToNamed("Offers");
      });
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> acceptJob(
      String requestId, DetailedRequestDetail request) async {
    try {
      showGetXLoading();
      var detailedRequest = await _repository.acceptJob(requestId, request);
      hideGetXLoading();

      Vehicle vehicles = await ApiHandler().getVehicle(request.vehicleId[0]);
      Service service = await ApiHandler().getService(request.serviceId);

      Get.toNamed("JobDetail",
          arguments: DetailedRequest(
              request: detailedRequest,
              vehicle: vehicles,
              service: service,
              estimation: Offer(items: [])));
    } catch (e) {
      handleError(e);
    }
  }

  Future<List<RequestsM>> getRequests() async {
    try {
      return await _repository.getRequests();
    } catch (e) {
      handleError(e);
    }
    return [];
  }

  Future<List<StatusRequest>> getTechnicianRequests() async {
    try {
      return await _repository.getTechnicianRequests();
    } catch (e) {
      handleError(e);
    }
    return [];
  }
}
