// To parse this JSON data, do
//
//     final statusRequest = statusRequestFromJson(jsonString);

import 'dart:convert';

import 'package:panda_technician/models/globalModels/description.dart';
import 'package:panda_technician/models/globalModels/price.dart';
import 'package:panda_technician/models/globalModels/schedule.dart';
import 'package:panda_technician/models/globalModels/serviceLocation.dart';
import 'package:panda_technician/models/offer/SentOffer.dart';
import 'package:panda_technician/models/requests/detailedRequestM.dart';
import 'package:panda_technician/models/service/service.dart';

List<StatusRequest> statusRequestFromJson(String str) => List<StatusRequest>.from(json.decode(str).map((x) => StatusRequest.fromJson(x)));

String statusRequestToJson(List<StatusRequest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StatusRequest {
    StatusRequest({
      required this.vehicleId ,
        this.technicianId = "",
       required this.createdAt,
       required this.schedule,
      required  this.serviceLocation,
      required this.updatedAt,
        this.serviceId = "",
       required this.price,
      required  this.description,
        this.id = "",
        this.requestStatus = "",
        this.customerId = "",
     required   this.vehiclesDetail,
      required  this.serviceDetail,
      required  this.customerInfo,
      required this.technicianInfo,
      this.isScheduled = false,
      required this.offerDetail
    });

    List<String> vehicleId;
    String technicianId;
    DateTime createdAt;
    Schedule schedule;
    ServiceLocation serviceLocation;
    DateTime updatedAt;
    String serviceId;
    Price price;
    Description description;
    String id;
    String requestStatus;
    String customerId;
    List<VehiclesDetail> vehiclesDetail;
    ServiceDetail serviceDetail;
    bool isScheduled; 
    Info customerInfo;
    Info technicianInfo;
    List<SentOffer> offerDetail;

    factory StatusRequest.fromJson(Map<String, dynamic> json) => StatusRequest(
        vehicleId: List<String>.from(json["vehicleId"].map((x) => x)),
        technicianId: json["technicianId"],
        createdAt: DateTime.parse(json["createdAt"]),
        schedule: Schedule.fromJson(json["schedule"]),
        serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        serviceId: json["serviceId"],
        price: Price.fromJson(json["price"]),
        description: Description.fromJson(json["description"]),
        id: json["id"],
        requestStatus: json["requestStatus"],
        customerId: json["customerId"],
        vehiclesDetail: List<VehiclesDetail>.from(json["vehiclesDetail"].map((x) => VehiclesDetail.fromJson(x))),
        serviceDetail: ServiceDetail.fromJson(json["serviceDetail"]),
        customerInfo: Info.fromJson(json["customerInfo"]),
        technicianInfo: Info.fromJson(json["technicianInfo"]),
        isScheduled: json["isScheduled"] ?? false,
        offerDetail: json["offerDetail"].length > 0 ? sentOfferFromJson(jsonEncode(json["offerDetail"])) : []
    );

    Map<String, dynamic> toJson() => {
        "vehicleId": List<dynamic>.from(vehicleId.map((x) => x)),
        "technicianId": technicianId,
        "createdAt": createdAt.toIso8601String(),
        "schedule": schedule.toJson(),
        "serviceLocation": serviceLocation.toJson(),
        "updatedAt": updatedAt.toIso8601String(),
        "serviceId": serviceId,
        "price": price.toJson(),
        "description": description.toJson(),
        "id": id,
        "requestStatus": requestStatus,
        "customerId": customerId,
        "vehiclesDetail": List<dynamic>.from(vehiclesDetail.map((x) => x.toJson())),
        // "serviceDetail": serviceDetail.toJson(),
        "customerInfo": customerInfo.toJson(),
        "technicianInfo": technicianInfo.toJson(),
        "isScheduled": isScheduled,
        "offerDetail": offerDetail
    };
}






class VehiclesDetail {
    VehiclesDetail({
       required this.model,
       required this.createdAt,
       required this.brand,
       required this.email,
       required this.make,
       required this.image,
       required this.updatedAt,
       required this.isFavorite,
       required this.plateNumber,
       required this.description,
       required this.id,
       required this.color,
       required this.transmission,
    });

    String model;
    DateTime createdAt;
    String brand;
    String email;
    String make;
    String image;
    DateTime updatedAt;
    bool isFavorite;
    int plateNumber;
    String description;
    String id;
    String color;
    String transmission;

    factory VehiclesDetail.fromJson(Map<String, dynamic> json) => VehiclesDetail(
        model: json["model"],
        createdAt: DateTime.parse(json["createdAt"]),
        brand: json["brand"],
        email: json["email"],
        make: json["make"],
        image: json["image"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        isFavorite: json["isFavorite"],
        plateNumber: json["plateNumber"],
        description: json["description"],
        id: json["id"],
        color: json["color"],
        transmission: json["transmission"],
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "createdAt": createdAt.toIso8601String(),
        "brand": brand,
        "email": email,
        "make": make,
        "image": image,
        "updatedAt": updatedAt.toIso8601String(),
        "isFavorite": isFavorite,
        "plateNumber": plateNumber,
        "description": description,
        "id": id,
        "color": color,
        "transmission": transmission,
    };
}


class ServiceDetail {
    ServiceDetail({
       required this.createdAt,
       required this.description,
       required this.id,
       required this.updatedAt,
       required this.title,
    });

    DateTime createdAt;
    String description;
    String id;
    DateTime updatedAt;
    String title;

    factory ServiceDetail.fromJson(Map<String, dynamic> json) => ServiceDetail(
        createdAt: DateTime.parse(json["createdAt"]),
        description: json["description"],
        id: json["id"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        title: json["title"],
    );

    Map<String, dynamic> toJson() => {
        "createdAt": createdAt.toIso8601String(),
        "description": description,
        "id": id,
        "updatedAt": updatedAt.toIso8601String(),
        "title": title,
    };
}
