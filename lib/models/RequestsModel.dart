import 'dart:convert';

List<RequestsModel> requestsFromJson(String str) => List<RequestsModel>.from(
    json.decode(str).map((x) => RequestsModel.fromJson(x)));

String requestsToJson(List<RequestsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestsModel {
  RequestsModel({
    this.id = 0,
    this.date = "",
    this.serviceType = "",
    this.customerName = "",
    this.customerAvater = "",
    this.customerCar = "",
    this.status = "",
    this.price = 2,
  });

  int id;
  String date;
  String serviceType;
  String customerName;
  String customerAvater;
  String customerCar;
  String status;
  int price;

  factory RequestsModel.fromJson(Map<String, dynamic> json) => RequestsModel(
        id: json["id"],
        date: json["date"],
        serviceType: json["serviceType"],
        customerName: json["customerName"],
        customerAvater: json["customerAvater"],
        customerCar: json["customerCar"],
        status: json["status"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date,
        "serviceType": serviceType,
        "customerName": customerName,
        "customerAvater": customerAvater,
        "customerCar": customerCar,
        "status": status,
        "price": price,
      };
}
