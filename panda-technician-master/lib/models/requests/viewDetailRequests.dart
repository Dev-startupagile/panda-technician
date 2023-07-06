// To parse this JSON data, do
//
//     final detailedRequestDetail = detailedRequestDetailFromJson(jsonString);

import 'dart:convert';

import 'package:panda_technician/models/globalModels/description.dart';
import 'package:panda_technician/models/globalModels/price.dart';
import 'package:panda_technician/models/globalModels/schedule.dart';
import 'package:panda_technician/models/globalModels/serviceLocation.dart';
import 'package:panda_technician/models/requests/detailedRequestM.dart';

DetailedRequestDetail detailedRequestDetailFromJson(String str) => DetailedRequestDetail.fromJson(json.decode(str));

String detailedRequestDetailToJson(DetailedRequestDetail data) => json.encode(data.toJson());

class DetailedRequestDetail {
    DetailedRequestDetail({
     required this.vehicleId,
        this.technicianId = "",
        this.requestStatus = "",
       required this.createdAt,
      required this.schedule,
      required  this.serviceLocation,
      required  this.updatedAt,
        this.serviceId = "",
      required  this.price,
      required  this.description,
        this.id = "",
        this.customerId = "",
      required this.customerInfo,
    });

    List<dynamic> vehicleId;
    String technicianId;
    String requestStatus;
    DateTime createdAt;
    Schedule schedule;
    ServiceLocation serviceLocation;
    DateTime updatedAt;
    String serviceId;
    Price price;
    Description description;
    String id;
    String customerId;
    Info customerInfo;

    factory DetailedRequestDetail.fromJson(Map<String, dynamic> json) => DetailedRequestDetail(
        vehicleId: json["vehicleId"],
        technicianId: json["technicianId"],
        requestStatus: json["requestStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        schedule: Schedule.fromJson(json["schedule"]),
        serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        serviceId: json["serviceId"],
        price: Price.fromJson(json["price"]),
        description: Description.fromJson(json["description"]),
        id: json["id"],
        customerId: json["customerId"],
        customerInfo: Info.fromJson(json["customerInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "vehicleId": vehicleId,
        "technicianId": technicianId,
        "requestStatus": requestStatus,
        "createdAt": createdAt.toIso8601String(),
        "schedule": schedule.toJson(),
        "serviceLocation": serviceLocation.toJson(),
        "updatedAt": updatedAt.toIso8601String(),
        "serviceId": serviceId,
        "price": price.toJson(),
        "description": description.toJson(),
        "id": id,
        "customerId": customerId,
        "customerInfo": customerInfo.toJson(),
    };
}





