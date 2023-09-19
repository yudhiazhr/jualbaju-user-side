import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pi_app/Screens/cart/cart_list_screen.dart';
import 'package:pi_app/Screens/home_screen.dart';

import '../api_connection/api_connection.dart';
import '../controller/product_controller.dart';
import '../users/model/clothes.dart';
import 'package:http/http.dart' as http;

import '../users/userPreferences/current_user.dart';

class ProductDetailScreen extends StatefulWidget {

  final Clothes? itemInfo;
  
  ProductDetailScreen({
    this.itemInfo
  });


  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {

  final itemDetailsController = Get.put(ItemDetailsController());
  final currentOnlineUser = Get.put(CurrentUser());

  addItemToCart () async {
    try {
      var res = await http.post(
        Uri.parse(API.addToCart),
        body: {
          "cart_user_id": currentOnlineUser.user.user_id_phone_number.toString(),
          "cart_product_id": widget.itemInfo!.product_id.toString(),
          "cart_quantity": itemDetailsController.quantity.toString(),
          "cart_size": widget.itemInfo!.product_size![itemDetailsController.size],
          
        }
      );
      if(res.statusCode == 200) //from flutter app the connection with api to server - success
      {
        var resBodyOfAddCart = jsonDecode(res.body);
        if(resBodyOfAddCart['success'] == true)
        {
          /* Fluttertoast.showToast(msg: "item saved to Cart Successfully."); */
           Get.snackbar('Success', 'item saved to Cart Successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));
        }
        else
        {
          Fluttertoast.showToast(msg: "Error Occur. Item not saved to Cart and Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
       Get.snackbar('Failed', errorMsg.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2));
      print("Error :: " + errorMsg.toString());
    }
  }

  Widget _buildImage() {
    return Center(
                  child: Container(
                    width: 400,
                    child: Card(
                      child: Container(
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(widget.itemInfo!.product_image!))
                          ),
                        ),
                      ),
                    ),
                  ),
                );
    }
  
  Widget _buildBrandAndNameProduct() {
    return Container(
            height: 80,
            child: Row(
            children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.itemInfo!.product_brand!, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),

                    Text(widget.itemInfo!.product_name!,  
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16,),),
                      
                    SizedBox(height: 5,),
                    Text("\I\D\R\. " + widget.itemInfo!.product_price.toString(), style: TextStyle(color: Colors.red,fontSize: 18,fontWeight: FontWeight.bold,),),
                    
                  ],
                ),
              ],
            ),
           );
          }
  
  Widget _buildDescription () {
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                Text("Description", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),  
                SizedBox(height: 10,),
                Text(widget.itemInfo!.product_description!, 
                style: TextStyle(fontSize: 15),)
                
              ]
            );
    
   }

  Widget _buildQuantityPart () {
    return Container(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
                      SizedBox(height: 12,),
                      Text(" Qty :",style: TextStyle(fontSize: 14),),
                      SizedBox(height: 5,),

                      Container(
                        height: 35,
                        width: 123,
                        decoration: BoxDecoration(
                        color: Colors.yellow.shade700,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      
                     child: Obx(
                        ()=> Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           //-
                            IconButton(
                              onPressed: ()
                              {
                                if(itemDetailsController.quantity - 1 >= 1)
                                {
                                  itemDetailsController.setQuantityItem(itemDetailsController.quantity - 1);
                                }
                                else
                                {
                                  Fluttertoast.showToast(msg: "Quantity must be 1 or greater than 1");
                                }
                              },
                              icon: const Icon(Icons.remove, color: Colors.black, size: 18,),
                            ),
                            
                            Text(
                              itemDetailsController.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            
                             //+
                            IconButton(
                              onPressed: ()
                              {
                                itemDetailsController.setQuantityItem(itemDetailsController.quantity + 1);
                              },

                              icon: const Icon(Icons.add, color: Colors.black, size: 18,),
                            ),
                          ],
                        ),
                      ),
                      ),

                      
        ],
      ),
    );
  }
 
  Widget _buildSize () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
              "Size:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10,),
        Row(
          children: <Widget>[
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo!.product_size!.length, (index) 
              {
                return Obx(
                    ()=> GestureDetector(
                      onTap: ()
                      {
                        itemDetailsController.setSizeItem(index);
                      },
                      child: Container(
                        height: 35,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: itemDetailsController.size == index
                                ? Colors.transparent
                                : Colors.yellow.shade700,
                          ),
                          color: itemDetailsController.size == index
                              ? Colors.yellow.shade700
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.itemInfo!.product_size![index].replaceAll("[", "").replaceAll("]", ""),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                );
              }),
            ),
          ],
        ), SizedBox(height: 5),
      ],
    );
  }
  
  Widget _buildStock () {
    return Row(
      children: <Widget>[
        Text("Stock : " + widget.itemInfo!.product_stock.toString(), style: TextStyle(fontSize: 14, ),),
         
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:  IconButton(
          icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
             },
            ),
        title: Text("Detail product", style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(onPressed: () {
            Get.to(() => CartListScreen());
          }, 
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.black,))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 10 ,right: 10, ),
        width: double.infinity,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                  _buildImage(),
                Container(
                  padding: EdgeInsets.only(left: 20 ,right: 20, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildBrandAndNameProduct(),
                      _buildQuantityPart(),
                   ],
                  ),
                ),
                 Container(
                  padding: EdgeInsets.only(left: 20 ,right: 20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          _buildSize(),
                        ],
                      ),
                      /* _buildStock(), */
                      _buildDescription(),
                    
                    SizedBox(height: 30,)
                   ],
                  ),
                 ),
              ],
            ),
          ],
        ),
      ) ,

       bottomNavigationBar: Container(
        padding: EdgeInsets.only(right: 30, left: 20, top: 15),
                    child: ListTile(
                    leading: Icon(Icons.add_shopping_cart_rounded, color: Colors.white,),
                    title: Text("Add to cart",style: TextStyle(fontSize: 20,color: Colors.white),),
                    onTap: () { 
                      addItemToCart();
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
    );
  }
}