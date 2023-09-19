import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pi_app/Screens/cart/cart_list_controller.dart';
import 'package:pi_app/Screens/order/order_now_screen.dart';
import 'package:pi_app/Screens/product_detail_screen.dart';
import 'package:pi_app/users/model/clothes.dart';
import 'package:pi_app/users/userPreferences/current_user.dart';
import '../../api_connection/api_connection.dart';
import '../../users/model/cart.dart';
import 'package:http/http.dart' as http;
import '../home_screen.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async
  {
    List<Cart> cartListOfCurrentUser = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.getCartList),
        body:
        {
          "currentOnlineUserID": currentOnlineUser.user.user_id_phone_number,
        }
      );

      if (res.statusCode == 200)
      {
        var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

        if (responseBodyOfGetCurrentUserCartItems['success'] == true)
        {
          (responseBodyOfGetCurrentUserCartItems['currentUserCartData'] as List).forEach((eachCurrentUserCartItemData)
          {
            cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Your cart list is empty.");
        }

       cartListController.setList(cartListOfCurrentUser);
      }
      else
      {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
      print("Error:: " + errorMsg.toString());
    }
    calculateTotalAmount();
  }

  calculateTotalAmount()
  {
    cartListController.setTotal(0);

    if(cartListController.selectedItemList.length > 0)
    {
      cartListController.cartList.forEach((itemInCart)
      {
        if(cartListController.selectedItemList.contains(itemInCart.cart_id))
        {
          double eachItemTotalAmount = (itemInCart.product_price!) * (double.parse(itemInCart.cart_quantity.toString()));

          cartListController.setTotal(cartListController.total + eachItemTotalAmount);
        }
      });
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
          getCurrentUserCartList();
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

  updateQuantityInUserCart(int cartID, int newQuantity) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.updateItemInCartList),
          body:
          {
            "cart_id": cartID.toString(),
            "cart_quantity": newQuantity.toString(),
          }
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfUpdateQuantity = jsonDecode(res.body);

        if(responseBodyOfUpdateQuantity["success"] == true)
        {
          getCurrentUserCartList();
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
  
  List<Map<String, dynamic>> getSelectedCartListItemsInformation() {
  List<Map<String, dynamic>>  SelectedCartListItemsInformation = [];
    if (cartListController.selectedItemList.length > 0) {
      cartListController.cartList.forEach((selectedCartListItem) {
        if (cartListController.selectedItemList.contains(selectedCartListItem.cart_id)) {
          Map<String, dynamic> itemInformation = {
            "product_id" : selectedCartListItem.cart_product_id,
            "product_brand" : selectedCartListItem.product_brand,
            "product_name" : selectedCartListItem.product_name,
            "cart_size" : selectedCartListItem.cart_size,
            "product_stock" :selectedCartListItem.product_stock,
            "cart_quantity" : selectedCartListItem.cart_quantity,
            "product_price" : selectedCartListItem.product_price,
            "product_image" : selectedCartListItem.product_image,
            "totalAmount" : selectedCartListItem.product_price! * selectedCartListItem.cart_quantity!,
          };
          SelectedCartListItemsInformation.add(itemInformation);
        }
      });
    }
    return SelectedCartListItemsInformation;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserCartList();
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
        title: Text("My Cart", style: TextStyle(color: Colors.black),),
        actions: [
          // select all button
          Obx(() => 
            IconButton(
              icon: Icon(cartListController.isSelectedAll 
                  ? Icons.check_box 
                  : Icons.check_box_outline_blank,
              color: cartListController.isSelectedAll
              ? Colors.black
              : Colors.black,
              ),
              onPressed: () {
                cartListController.setIsSelectedAllItems();
                cartListController.clearAllSelectedItems();

                if(cartListController.isSelectedAll) {
                  cartListController.cartList.forEach((eachItem) {
                    cartListController.addSelectedItem(eachItem.cart_id!);
                  });
                }
                calculateTotalAmount();
              },
            )
          ),

          // delete selected item
          GetBuilder(
            init: CartListController(),
            builder: (c) {
              if(cartListController.selectedItemList.length>0) {
                return IconButton(
                   icon: Icon(Icons.delete_sweep, color: Colors.redAccent,),
                    onPressed: () async {
                      var responseFromDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text("Delete"),
                          content: Text("Are you sure to delete selected items from your cart?"),
                          actions: [
                            TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("No", style: TextStyle(color: Colors.black),)),
                            
                            TextButton(
                            onPressed: () {
                              Get.back(result: "yesDelete");
                            },
                            child: Text("Yes", style: TextStyle(color: Colors.black),)),
                          ],
                        )
                      );
                      if (responseFromDialogBox == "yesDelete") {
                        cartListController.selectedItemList.forEach((selectedItemsUserCartID) {
                          // delete selected items now
                          deleteSelectedItemsFromUserCartList(selectedItemsUserCartID);
                        }); 
                      }
                      calculateTotalAmount();
                    },
                  );
                } else {
                return Container();
              }
            }
          ),

        ],
      ),

      body: Obx(() => 
        cartListController.cartList.length > 0 
          ? ListView.builder(
            itemCount: cartListController.cartList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Cart cartModel =  cartListController.cartList[index];
            
              Clothes clothesModel = Clothes(
                product_id: cartModel.cart_product_id,
                product_brand: cartModel.product_brand,
                product_name: cartModel.product_name,
                product_size: cartModel.product_size,
                product_price: cartModel.product_price,
                product_rating: cartModel.product_rating,
                product_stock: cartModel.product_stock,
                product_description: cartModel.product_description,
                product_image: cartModel.product_image,
              );

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  GetBuilder(
                    init: CartListController(),
                    builder: (c) {
                    return IconButton(
                        icon: Icon(cartListController.selectedItemList.contains(cartModel.cart_id)
                          ? Icons.check_box 
                          : Icons.check_box_outline_blank_rounded,
                          color: cartListController.isSelectedAll
                          ? Colors.black
                          : Colors.black
                        ),
                          onPressed: () {
                            if(cartListController.selectedItemList.contains(cartModel.cart_id)) {
                              cartListController.deleteSelectedItem(cartModel.cart_id!);
                            } else {
                              cartListController.addSelectedItem(cartModel.cart_id!);
                            }

                            calculateTotalAmount();
                          },);
                  }),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailScreen(itemInfo: clothesModel,));
                      },
                      child:
                      Container(
                          child: Card(
                          child: Container(
                            color: Colors.grey.shade100,
                            height: 140,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          cartModel.product_brand!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                        ),
                                        Text(
                                          cartModel.product_name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              "\I\D\R\. " + cartModel.product_price.toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.deepOrange.shade900,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Text(
                                              "Size: ${cartModel.cart_size!.replaceAll('[', '').replaceAll(']', '')}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Text(
                                              " Qty :",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(height: 5),
                                            Container(
                                              height: 35,
                                              width: 123,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow.shade700,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove, color: Colors.black, size: 18),
                                                    onPressed: () {
                                                      if (cartModel.cart_quantity! - 1 >= 1) {
                                                        updateQuantityInUserCart(cartModel.cart_id!, cartModel.cart_quantity! - 1);
                                                      }
                                                    },
                                                  ),
                                                  Text(
                                                    cartModel.cart_quantity.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.add, color: Colors.black, size: 18),
                                                    onPressed: () {
                                                      updateQuantityInUserCart(cartModel.cart_id!, cartModel.cart_quantity! + 1);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(cartModel.product_image!),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ),
                    )
                  )
                ],
              ),
            );

            },
          )
          : Center(
            child: Text("Cart is empty"),
          )
      ),
      
      bottomNavigationBar: GetBuilder(
        init: CartListController(),
        builder: (c) {
          return Container(
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
                      child: Obx(() => Text("\I\D\R\. " + cartListController.total.toStringAsFixed(0),
                      maxLines: 1,
                      style: TextStyle( fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrange.shade900,),
                        )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 11,),

                Container(
                  padding: EdgeInsets.only(right: 20, left: 20, top: 15),
                    child: ListTile(
                    leading: Icon(Icons.shopping_cart_checkout, color: Colors.white,),
                    title: Text("Checkout now",style: TextStyle(fontSize: 20,color: Colors.white),),
                    onTap: () { 
                      cartListController.selectedItemList.length > 0
                        ? Get.to(() =>OrderNowScreen(
                          selectedCartListItemsInfo: getSelectedCartListItemsInformation(),
                          totalAmount: cartListController.total,
                          selectedCartIDs: cartListController.selectedItemList,
                        ))
                        : null ;
                    },
                    trailing: Container(
                      width: 30 , height: 30,
                      child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
                    ),
                  ),
                      height: 70,
                      width: double.infinity,
                      decoration:BoxDecoration(
                        color: cartListController.selectedItemList.length > 0 
                        ? Colors.black 
                        : Colors.grey.shade400,
                        borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
                        
                      ),
                      ),
              ],
            ),
          );
        },
        )
    );
  }
}