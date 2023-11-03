


import 'package:panda_technician/models/offer.dart';
import 'package:panda_technician/models/requests/detailedRequestM.dart';
import 'package:panda_technician/models/requests/requests.dart';
import 'package:panda_technician/models/service/service.dart';
import 'package:panda_technician/models/vehicle/vehicle.dart';
import 'package:panda_technician/screens/requests/requestes.dart';

class DetailedRequest{


  DetailedRequest({
     required this.request,
     required this.vehicle,
     required this.service,
     required this.estimation
  });

  DetailedRequestM request;
  Vehicle vehicle;
  Service service;
  Offer estimation;

}