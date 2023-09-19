import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pi_app/Screens/home_screen.dart';
import 'package:pi_app/users/model/user.dart';

import '../api_connection/api_connection.dart';
import '../users/model/order.dart';
import '../users/userPreferences/current_user.dart';

class OrderConfirmationScreen extends StatelessWidget {
  
  final List<int>? selectedCartIDs;
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final String? deliverySystem;


  OrderConfirmationScreen ({
    this.selectedCartIDs,
    this.deliverySystem,
    this.selectedCartListItemsInfo,
    this.totalAmount,
});

  CurrentUser currentUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image.network('https://cdni.iconscout.com/illustration/premium/thumb/order-placed-4283423-3581435.png'),
              ),
              Text('Successfully order', style: TextStyle(fontSize: 20,)),
              SizedBox(height: 10,),
              Text('Your package will come soon', style: TextStyle(fontSize: 20,)),
              SizedBox(height: 10,),

              Text(' Have a good day 🥳', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, ),),
              SizedBox(height: 10,),
              
              
              Material(
              color: Colors.yellow.shade700,
              
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {
                  
                    //save order info
                    Get.to(() => HomeScreen());
                 
                },
                borderRadius: BorderRadius.circular(30),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  child: Text(
                    "Back to home",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
            ],
          ),
          
        ),
    );
  }
}