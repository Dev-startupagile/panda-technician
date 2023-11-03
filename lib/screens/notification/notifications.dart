import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/components/globalComponents/Footer.dart';
import 'package:panda_technician/components/globalComponents/emptyScreen.dart';
import 'package:panda_technician/components/offerComponents/SpecificSingleOfferCard.dart';
import 'package:panda_technician/screens/requests/StatusRequest.dart';
import 'package:panda_technician/services/serviceDate.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
List<StatusRequest> statusRequest=[];
List<int> canceldList = [];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    getOffers();
  }


void getOffers() async{
  List<StatusRequest>  tempStatusRequest = (await ApiHandler().getTechnicianRequests())! ;
      // canceld = (await ApiHandler().getCanceldRequest())!;
      // print("KKKKK: " + tempStatusRequest[0].description);
  Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
      statusRequest  =  tempStatusRequest;
       
    }));
}
  

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  isEmpty(){
  return  !statusRequest.any((element) => element.requestStatus == "PENDING");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     appBar: AppBar(
       
       centerTitle: true,
       foregroundColor: Colors.black, title: const Text("Notifications",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black)), backgroundColor: Colors.white,),
      body: Container(
       
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding:const EdgeInsets.all(0),
      child: !isEmpty()? ListView.builder(
            itemCount: statusRequest.length,
            itemBuilder: (
            context,index){
               return 
                (statusRequest[index].requestStatus == "PENDING" && !canceldList.contains(index)) ? 
               SpecificSingleOfferCard(time:changeToAmPm(statusRequest[index].schedule.time) , date: getUsDateFormat(statusRequest[index].schedule.date),requestId: statusRequest[index].id,request: statusRequest[index],cancelOffer: ((){
              setState(() {
                canceldList.add(index);
              });

               })) :
               SizedBox();
               }):      
               EmptyScreen(title: "There Are No Notifications", subTitle: 'Empty Notifications')
               
      
    ));
  }
}