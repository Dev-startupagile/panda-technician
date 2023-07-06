

// ignore_for_file: prefer_const_constructors, must_be_immutable

  import 'package:flutter/material.dart';
import 'package:panda_technician/apiHandler/apiHandler.dart';
import 'package:panda_technician/components/messageComponents/dialogBox.dart';
import 'package:panda_technician/models/RequestsModel.dart';
import 'package:panda_technician/models/requests/requests.dart';
import 'package:panda_technician/screens/requests/StatusRequest.dart';
import 'package:panda_technician/screens/requests/requestes.dart';

class SpecificSingleOfferCard extends StatelessWidget {
   SpecificSingleOfferCard({super.key, required this.time, required this.date, required this.requestId, required this.request, required this.cancelOffer});
    String time;
    String date;
    String requestId;
    StatusRequest request;
    Function cancelOffer;

  @override
  Widget build(BuildContext context) {
    return  Container(
      
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      width: MediaQuery.of(context).size.width *0.90,
      decoration: BoxDecoration(
        color: Colors.white,
                  borderRadius: BorderRadius.circular(10),

      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
                          Container(
          alignment: Alignment.center,
          height: 70,
          width: MediaQuery.of(context).size.width *0.98,
          decoration: BoxDecoration(color: Colors.transparent,
          ),
          
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(height: 60,width:60, image: AssetImage("assets/car.png"),)
              , Container(alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.50,
              height: 50,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(
                
                children: <Widget>[
                  Text("Mobile Technician",textAlign: TextAlign.left, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                  Text("Diagnostic Service", style: TextStyle(fontSize: 14, color: Colors.grey[400])),

              ],)), Container(alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.25,
              height: 50,
              decoration: BoxDecoration(color: Colors.transparent),
              child: Column(children: <Widget>[
                  Text(time, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                  Text(date, style: TextStyle(fontSize: 14, color: Colors.grey[400])),

              ],)),
             

          ],)
        ),
        Container(
          height:70,
          margin: EdgeInsets.fromLTRB(10,0,10,0),
          alignment: Alignment.center ,
          decoration: BoxDecoration(color: Colors.white),
          child:        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
             Container(  
              width:120,//
              height:40,
              
              decoration:  BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(255, 44, 42, 42)),
              margin:const EdgeInsets.fromLTRB(0, 10, 0, 0),  
              child:TextButton( 
                
         onPressed: () {

           DialogBox(context, "Message", "Are you sure you want to cancel this Offer?", "No", "Yes", ((){
                // if no
                Navigator.pop(context);
           }), (() async {
             //if yes
                            ApiHandler().rejectJob(request.id,request.technicianInfo.id,request.customerId,context);


           }));

          },
          child:const Text('Cancel', style: TextStyle(fontSize: 14,color: Colors.white), textAlign: TextAlign.center,),
)  
            ),
               Container(  
              width:120,//
              height:40,
              
              decoration:  BoxDecoration(borderRadius: BorderRadius.circular(10), color:Color.fromARGB(255, 92, 86, 86)),
              margin:const EdgeInsets.fromLTRB(0, 10, 0, 0),  
              child:TextButton(
                
         onPressed: () {
           ApiHandler().jobSpecificDetailed(requestId, context,request);

          },
          child:const Text('Open', style: TextStyle(fontSize: 14,color: Colors.white), textAlign: TextAlign.center,),
)  

            )
        ],)
        )

    ],)
    );
  }
}