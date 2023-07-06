// To parse this JSON data, do
//
//     final detailedRequestM = detailedRequestMFromJson(jsonString);

import 'dart:convert';

import 'package:panda_technician/models/globalModels/description.dart';
import 'package:panda_technician/models/globalModels/price.dart';
import 'package:panda_technician/models/globalModels/schedule.dart';
import 'package:panda_technician/models/globalModels/serviceLocation.dart';
import 'package:panda_technician/models/offer/SentOffer.dart';

DetailedRequestM detailedRequestMFromJson(String str) => DetailedRequestM.fromJson(json.decode(str));

String detailedRequestMToJson(DetailedRequestM data) => json.encode(data.toJson());

class DetailedRequestM {
    DetailedRequestM({
        this.id = "",
       required this.vehicleId ,
        this.technicianId = "",
        this.requestStatus = "",
      required this.createdAt,
       required this.schedule,
       required this.serviceLocation,
       required this.updatedAt,
        this.serviceId = "",
       required this.price,
     required   this.description,
        this.customerId = "",
       required this.customerInfo,
      required  this.technicianInfo,
      // required this.sentOffer
    });

    String id;
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
    String customerId;
    Info customerInfo;
    Info technicianInfo;
    // SentOffer sentOffer;

    factory DetailedRequestM.fromJson(Map<String, dynamic> json) => DetailedRequestM(
        id: json["id"],
        vehicleId: json["vehicleId"],
        technicianId: json["technicianId"]?? "",
        requestStatus: json["requestStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        schedule: Schedule.fromJson(json["schedule"]),
        serviceLocation: ServiceLocation.fromJson(json["serviceLocation"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        serviceId: json["serviceId"],
        price: Price.fromJson(json["price"]),
        description: Description.fromJson(json["description"]),
        customerId: json["customerId"],
        customerInfo: Info.fromJson(json["customerInfo"]),
        technicianInfo: Info.fromJson(json["technicianInfo"]),
        // sentOffer: SentOffer.fromJson(json["offerDetail"] == null? SentOffer(items: []) : json["offerDetail"].length == 0? SentOffer(items:[]) : json["offerDetail"][0]),

    );

    Map<String, dynamic> toJson() => {
        "id": id,
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
        "customerId": customerId,
        "customerInfo": customerInfo.toJson(),
        "technicianInfo": technicianInfo.toJson(),
        // "offerDetail": sentOffer.toJson()
    };
}

class Info {
    Info({
        this.phoneNumber = "",
        this.userRole = "",
        this.subscription = "",
      required  this.createdAt,
        this.fullName = "",
        this.state = "",
        this.city = "",
        this.isActive = false,
        this.userId = "",
        this.profilePicture = "",
        required this.updatedAt,
        this.id = "",
        this.zipCode =000,
        this.street = "",
    });

    String phoneNumber;
    String userRole;
    String subscription;
    DateTime createdAt;
    String fullName;
    String state;
    String city;
    bool isActive;
    String userId;
    String profilePicture;
    DateTime updatedAt;
    String id;
    int zipCode;
    String street;

    factory Info.fromJson(Map<String, dynamic> json) => Info(
        phoneNumber: json["phoneNumber"],
        userRole: json["userRole"],
        subscription: json["subscription"],
        createdAt: DateTime.parse(json["createdAt"]),
        fullName: json["fullName"],
        state: json["state"],
        city: json["city"],
        isActive: json["isActive"],
        userId: json["userID"],
        profilePicture: json["profilePicture"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        id: json["id"],
        zipCode: json["zipCode"],
        street: json["street"],
    );

    Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "userRole": userRole,
        "subscription": subscription,
        "createdAt": createdAt.toIso8601String(),
        "fullName": fullName,
        "state": state,
        "city": city,
        "isActive": isActive,
        "userID": userId,
        "profilePicture": profilePicture,
        "updatedAt": updatedAt.toIso8601String(),
        "id": id,
        "zipCode": zipCode,
        "street": street,
    };
}


