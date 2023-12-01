import 'dart:convert';
import 'package:panda_technician/models/RequestsModel.dart';
import 'package:panda_technician/models/globalModels/description.dart';
import 'package:panda_technician/models/globalModels/price.dart';
import 'package:panda_technician/models/globalModels/schedule.dart';
import 'package:panda_technician/models/globalModels/serviceLocation.dart';
import 'package:panda_technician/screens/requests/StatusRequest.dart';

List<RequestsM> RequestsMFromJson(String str) =>
    List<RequestsM>.from(json.decode(str).map((x) => RequestsM.fromJson(x)));

String RequestsMToJson(List<RequestsM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestsM {
  RequestsM({
    required this.vehicleId,
    required this.technicianId,
    required this.requestStatus,
    required this.createdAt,
    required this.schedule,
    required this.serviceLocation,
    required this.updatedAt,
    required this.serviceId,
    required this.price,
    required this.description,
    required this.vehiclesDetail,
    required this.id,
    required this.customerId,
  });

  List<dynamic> vehicleId;
  String technicianId;
  String requestStatus;
  String createdAt;
  Schedule schedule;
  ServiceLocation serviceLocation;
  String updatedAt;
  String serviceId;
  Price price;
  Description description;
  String id;
  String customerId;
  List<VehiclesDetail> vehiclesDetail;

  factory RequestsM.fromJson(Map<String, dynamic> json) => RequestsM(
        vehicleId: json["vehicleId"],
        technicianId: json["technicianId"],
        requestStatus: json["requestStatus"],
        createdAt: json["createdAt"],
        schedule: Schedule.fromJson(json["schedule"]),
        serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
        updatedAt: json["updatedAt"],
        serviceId: json["serviceId"],
        price: Price.fromJson(json["price"]),
        description: Description.fromJson(json["description"]),
        id: json["id"],
        customerId: json["customerId"],
        vehiclesDetail: List<VehiclesDetail>.from(
            json["vehiclesDetail"].map((x) => VehiclesDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "technicianId": technicianId,
        "requestStatus": requestStatus,
        "createdAt": createdAt,
        "schedule": schedule.toJson(),
        "serviceLocation": serviceLocation.toJson(),
        "updatedAt": updatedAt,
        "serviceId": serviceId,
        "price": price.toJson(),
        "description": description.toJson(),
        "id": id,
        "customerId": customerId,
        "vehiclesDetail":
            List<dynamic>.from(vehiclesDetail.map((x) => x.toJson())),
      };
}
