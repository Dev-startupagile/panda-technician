// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panda_technician/app/modules/job_offer/job_offer.controller.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/app/modal/auto_service/service_request_model.dart';

class SpecificSingleOfferCard extends GetView<JobOfferController> {
  SpecificSingleOfferCard(
      {super.key,
      required this.time,
      required this.date,
      required this.requestId,
      required this.request,
      required this.cancelOffer});
  String time;
  String date;
  String requestId;
  ServiceRequestModel request;
  Function cancelOffer;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 80,
                width: MediaQuery.of(context).size.width * 0.98,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      height: 60,
                      width: 60,
                      image: AssetImage("assets/car.png"),
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: 50,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Mobile Technician1",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            Text("Diagnostic Service",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[400])),
                          ],
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 60,
                        decoration: BoxDecoration(color: Colors.transparent),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    time,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(date,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400])),
                                ],
                              ),
                            ),
                            if (request.isScheduled)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.greenAccent,
                                ),
                                child: Text(
                                  "Scheduled",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              )
                          ],
                        )),
                  ],
                )),
            Container(
                height: 70,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        width: 120, //
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 44, 42, 42)),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextButton(
                          onPressed: () {
                            DialogBox(
                                context,
                                "Message",
                                "Are you sure you want to cancel this Offer?",
                                "No",
                                "Yes", (() {
                              // if no
                              Get.back();
                            }), (() async {
                              //if yes
                              controller.rejectJob(
                                  request.id,
                                  request.technicianInfo!.id,
                                  request.customerId);
                            }));
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        )),
                    Container(
                        width: 120, //
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 92, 86, 86)),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextButton(
                          onPressed: () {
                            controller.goToServiceRequestDetailPage(
                                requestId, request);
                          },
                          child: const Text(
                            'Open',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))
                  ],
                ))
          ],
        ));
  }
}
