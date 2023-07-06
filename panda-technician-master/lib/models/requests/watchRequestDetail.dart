


import 'package:panda_technician/models/requests/detailedRequestM.dart';
import 'package:panda_technician/models/requests/requests.dart';
import 'package:panda_technician/models/requests/viewDetailRequests.dart';
import 'package:panda_technician/models/service/service.dart';
import 'package:panda_technician/models/vehicle/vehicle.dart';
import 'package:panda_technician/screens/requests/requestes.dart';

class watchDetailedRequest{


  watchDetailedRequest({
     required this.request,
     required this.vehicle,
     required this.service,
  });

  DetailedRequestDetail request;
  Vehicle vehicle;
  Service service;
}