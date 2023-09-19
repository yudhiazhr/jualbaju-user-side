import 'dart:convert';

import 'package:flutter/material.dart' ;
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pi_app/Screens/cart/cart_list_controller.dart';
import 'package:pi_app/Screens/order/order_now_controller.dart';
import 'package:pi_app/users/model/user.dart';

import '../../api_connection/api_connection.dart';
import '../../order/order_confScreen.dart';
import '../../users/model/order.dart';
import '../../users/userPreferences/current_user.dart';
import '../home_screen.dart';

class OrderNowScreen extends StatelessWidget {

  final List<int>? selectedCartIDs;
  final List<Map<String, dynamic>>? selectedCartListItemsInfo;
  final double? totalAmount;
  final String? deliverySystem;
  
  OrderNowScreen({
    this.selectedCartListItemsInfo, 
    this.totalAmount, 
    this.deliverySystem,
    this.selectedCartIDs,
    });

  final CurrentUser _currentUser = Get.put(CurrentUser());
  OrderNowController orderNowController = Get.put(OrderNowController());

  List<String> deliverySystemNamesList = ["JNE", "TIKI","POS"]; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
              )),
          title: Text(
            "Checkout",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.only(bottom: 15),
          children: [

            // shipment address
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10,),
              child: Text("Shipment address :", style: TextStyle(fontSize: 18,),),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              color: Colors.grey.shade100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                    Text(_currentUser.user.user_name + " (" + _currentUser.user.user_id_phone_number + ")",style: TextStyle(fontWeight: FontWeight.bold,),),
                                    SizedBox(height: 5,),
                                    Text(
                                      _currentUser.user.user_street_address + ", " +  _currentUser.user.user_city + ", " +
                                      _currentUser.user.user_state+ ", " +
                                      _currentUser.user.user_country + ", " +
                                      _currentUser.user.user_zipcode,
                                      maxLines: 10,),
                                  ]
                                ),
                              ),
                            ),
            ),
            
          
            // show the items to be purchased
            displaySelectedItemsFromUserCart(),

            // delivery
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Text("Delivery system :", style: TextStyle(fontSize: 18,),),
            ),

            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 8),
              child: Column(
                children: deliverySystemNamesList.map((deliverySystemName) {
                    return Obx(() => 

                    RadioListTile<String>(
                      tileColor: Colors.grey.shade200,
                      dense: true,
                      activeColor: Colors.blue,
                      title: Text(deliverySystemName, style: TextStyle(fontSize: 16),),
                      value: deliverySystemName,
                      groupValue: orderNowController.deliverySys,
                      onChanged: (newDeliverySystemValue) {
                        orderNowController.setDeliverySystem(newDeliverySystemValue!);
                        },
                      ),

                    );
                  }).toList(),
              ),
            ),
          ],
      ),
       bottomNavigationBar: Container(
            height: 100,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20,),
                      child: Text(
                        "Total :",style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold,),)
                        ),
                    Container(
                      padding: EdgeInsets.only(right: 20,),
                      child: Text("\I\D\R\. " + totalAmount!.toStringAsFixed(0),
                      maxLines: 1,
                      style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade900,),
                        )
                      ),
                    
                  ],
                ),
                SizedBox(height: 11,),

                Container(
                  padding: EdgeInsets.only(right: 20, left: 20, top: 15),
                    child: ListTile(
                    leading: Icon(Icons.shopping_cart_checkout, color: Colors.white,),
                    title: Text("Buy now",style: TextStyle(fontSize: 20,color: Colors.white),),
                    onTap: () { 
                      
                      makePayment(amount: totalAmount!.toStringAsFixed(0) ,currency: 'IDR');
                     
                    },
                    trailing: Container(
                      width: 30 , height: 30,
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                    ),
                  ),
                      height: 70,
                      width: double.infinity,
                      decoration:BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
                        
                      ),
                      ),
              ],
            ),
          )
    );
  }

  saveNewOrderInfo() async
  {
    String selectedItemsString = selectedCartListItemsInfo!.map((eachSelectedItem)=> jsonEncode(eachSelectedItem)).toList().join("||");
    try
    {
      var res = await http.post(
        Uri.parse(API.addOrder),
        body:
        {
          'order_id': "1",
          'user_id_phone_number': _currentUser.user.user_id_phone_number,
          'order_selectedItems': selectedItemsString,
          'order_deliverySystem': orderNowController.deliverySys.toString(),
          'order_totalAmount': totalAmount.toString(),
          'order_status': "new",
          'dateTime': DateTime.now().toString(),
          'user_city': _currentUser.user.user_city,
          'user_country': _currentUser.user.user_country,
          'user_state': _currentUser.user.user_state,
          'user_street_address': _currentUser.user.user_street_address,
          'user_zipcode': _currentUser.user.user_zipcode,
          'user_name': _currentUser.user.user_name,
        }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfAddNewOrder = jsonDecode(res.body);

        if(responseBodyOfAddNewOrder["success"] == true)
        {

          selectedCartIDs!.forEach((eachSelectedItemCartID)
          {
            deleteSelectedItemsFromUserCartList(eachSelectedItemCartID);
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Error:: \nyour new order do NOT placed.");
        }
      }
    }
    catch(erroeMsg)
    {
      Fluttertoast.showToast(msg: "Error: " + erroeMsg.toString());
    }
  }

  deleteSelectedItemsFromUserCartList(int cartID) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.deleteSelectedItemsFromCartList),
          body:
          {
            "cart_id": cartID.toString(),
          }
      );

      if(res.statusCode == 200)
      {
        var responseBodyFromDeleteCart = jsonDecode(res.body);

        if(responseBodyFromDeleteCart["success"] == true)
        {
          Get.snackbar('Success', 'your new order has been placed Successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));

          Get.to(() => OrderConfirmationScreen());
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
      }
    }
    catch(errorMessage)
    {
      print("Error: " + errorMessage.toString());

      Fluttertoast.showToast(msg: "Error: " + errorMessage.toString());
    }
  }

  Map<String, dynamic>? paymentIntentData;
  Future<void> makePayment(
      {required String amount, required String currency}) async {
    try {
      paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'Arraxys',
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
        )).then((value) {});
        displayPaymentSheet();
      }
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();
    if (orderNowController.deliverySys.length > 0 ) {
      Get.snackbar('Payment', 'Payment Successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));
      await Future.delayed(Duration(seconds: 2));
      saveNewOrderInfo();
    } else {
      Fluttertoast.showToast(msg: "Please choose delivery system.");
    }
  } on Exception catch (e) {
    if (e is StripeException) {
      print("Error from Stripe: ${e.error.localizedMessage}");
    } else {
      print("Unforeseen error: ${e}");
    }
  } catch (e) {
    print("exception: $e");
  }
}

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51NGE2jLqP2nptMgKjHehnvM0ZjmmFc8FT26JO3d9yoUbPtcwH036Ni1JPOkJi5koJCwrP4iRVtElLuswZbRoDKKq00GT2tUTDm',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);
      
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }

 
  displaySelectedItemsFromUserCart() {
    return Column(
      children: List.generate(selectedCartListItemsInfo!.length, (index) {
        Map<String, dynamic> eachSelectedItem = selectedCartListItemsInfo![index];

        return Container(
                margin: EdgeInsets.fromLTRB(
                  16,
                  index == 0 ? 16 : 8,
                  16,
                  index == selectedCartListItemsInfo!.length - 1 ? 16 : 8,
                ),
                child: Row(
                  children: [

                    // image
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Card(
                          child: Container(
                            color: Colors.grey.shade100,
                            height: 130,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                // image
                                Container(
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(eachSelectedItem["product_image"]),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[

                                        Text(
                                          eachSelectedItem["product_brand"],
                                          maxLines: 1, 
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),

                                        Text(
                                          eachSelectedItem["product_name"],
                                          maxLines: 1,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        SizedBox(height: 5),

                                        Row(
                                          children: [
                                            Text(
                                              "Size: " + eachSelectedItem["cart_size"].replaceAll("[", "").replaceAll("]", ""),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "Qty: " + eachSelectedItem["cart_quantity"].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\I\D\R\. " + eachSelectedItem["totalAmount"].toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange.shade900),
                                            ),
                                            Text(
                                              eachSelectedItem["cart_quantity"].toString() + " x " + eachSelectedItem["product_price"].toString(),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
