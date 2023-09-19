import 'dart:convert';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pi_app/Screens/cart/cart_list_screen.dart';
import 'package:pi_app/Screens/product_detail_screen.dart';
import 'package:pi_app/Screens/profile_screen.dart';
import 'package:pi_app/users/userPreferences/current_user.dart';
import '../api_connection/api_connection.dart';
import '../users/model/clothes.dart';
import 'package:http/http.dart' as http;

import 'search/search_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  TextEditingController searchController = TextEditingController();

  Widget _buildImageSlider() {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 150,
        child: Carousel(
          radius: Radius.circular(10),
          autoplay: true,
          showIndicator: false,
          images: [
            NetworkImage(
                "https://sepatucompass.com/_next/static/images/desktop-3ddc9c47fbbd4ce541f66f51845a4604.jpg"),
            NetworkImage(
                "https://sepatucompass.com/_next/static/images/body-3-a5420a06410c70f60e4fb196f504b4dd.jpg"),
            NetworkImage(
                "https://sepatucompass.com/_next/static/images/body-1-eb306c39985746c86e8dbed32ccdc5e1.jpg")
          ],
        ),
      ),
    );
  }

  Widget _singleProduct () {
    return Card(
            child: Container(
                  color: Colors.grey.shade100,
                  height: 270,
                  width: 165,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 170,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage("")),
                        ),
                      ),
                      SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nike", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),),
                              Text("Air max 270", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),),
                              SizedBox(height: 10,),
                              Text("\I\D\R\. 120.000", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange.shade900,),
                              ),
                            ],
                          ),
                        ),
                       
                     ],
                   ),
                 ),
                 );
  }

  Widget _singleProduct2 () {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10,),
            child: Card(
             child: Container(
              color: Colors.grey.shade100,
              height: 130,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage("")),
                          )
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                              Text("Nike", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),),
                              Text("Air jordan panda", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                            SizedBox(height: 10,),
                           Text("\I\D\R\. 120.000", 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.deepOrange.shade900,),
                              ),
                          ],
                        ),
                      ),
                      ]
                    ),
              ),
            ),
          ),
      ],
    );
  }

 void _performSearch() {
    Get.to(() => SearchItems(typedKeyWords : searchController.text));
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CurrentUser(),
      initState: (currentState) {
        _rememberCurrentUser.getUserInfo();
      },
      builder: (controller) {
        return Scaffold(
      appBar: AppBar(
        title: Text("ARRAXYS", style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onPressed: () {
              Get.to(() => ProfileScreen());
             },
            ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
              onPressed: () {
                Get.to(() => CartListScreen());
              },
              ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(padding: EdgeInsets.only(left: 20 ,right: 20, top: 10, bottom: 10),
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              _performSearch();
            },
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: IconButton(
                onPressed: () {
                  Get.to(() => SearchItems(typedKeyWords : searchController.text));
                }, 
              icon: Icon(Icons.search_rounded, color: Colors.grey.shade600,)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                
              ),
              contentPadding: EdgeInsets.only(top: 10),
              filled: true,
              fillColor: Colors.white,
              ),
            ),
          ),         
        ),
      ),
      
      body: SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10 ,right: 10, top: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

                _buildImageSlider(),

                SizedBox(height: 15,),
                Text("Featured", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                SizedBox(height: 10,),

                trendingMostPopularClothItemWidget(context),

            SizedBox(height: 10,),

            Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Newest", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,),),
                SizedBox(height: 10,),

                allItemWidget(context),

              ],
            ),
          ),
          ],
        ),
      ),
    ),
        );
      },
    );
  }

 Widget trendingMostPopularClothItemWidget(context)
  {
    return FutureBuilder(
      future: getTrendingClothItems(),
      builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot)
      {
        if(dataSnapShot.connectionState == ConnectionState.waiting)
        {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(dataSnapShot.data == null)
        {
          return const Center(
            child: Text(
              "No Trending item found",
            ),
          );
        }
        if(dataSnapShot.data!.length > 0)
        {
          return SizedBox(
            height: 290,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index)
              {
                Clothes eachClothItemData = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(() => ProductDetailScreen(itemInfo: eachClothItemData));
                  },
                  child: Card(
                  child: Container(
                  color: Colors.grey.shade100,
                  height: 270,
                  width: 165,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 170,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(eachClothItemData.product_image!)),
                        ),
                      ),
                      SizedBox(height: 15,),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(eachClothItemData.product_brand!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                              Text(eachClothItemData.product_name!, style: TextStyle( fontSize: 16,),),
                              SizedBox(height: 10,),
                                  Text("\I\D\R\. " + eachClothItemData.product_price.toString(),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange.shade900,),),
                                  
                            ],
                          ),
                        ),
                       
                     ],
                   ),
                 ),
                 ),
                  
                );
              },
            ),
          );
        }
        else
        {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }

 Widget allItemWidget(context)
  {
    return FutureBuilder(
      future: getAllClothItems(),
        builder: (context, AsyncSnapshot<List<Clothes>> dataSnapShot)
        {
          if(dataSnapShot.connectionState == ConnectionState.waiting)
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if(dataSnapShot.data == null)
          {
            return const Center(
              child: Text(
                "No Trending item found",
              ),
            );
          }
          if(dataSnapShot.data!.length > 0)
          {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
                Clothes eachClothItemRecord = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(() => ProductDetailScreen(itemInfo: eachClothItemRecord));

                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                          child: Card(
                          child: Container(
                            color: Colors.grey.shade100,
                            height: 130,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    
                                    Container(
                                      width: 200,
                                      padding: EdgeInsets.only(left: 15,),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                            Text(eachClothItemRecord.product_brand!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17,),),
                                            Text(eachClothItemRecord.product_name!, style: TextStyle( fontSize: 17,),),
                                          SizedBox(height: 10,),
                                        Text("\I\D\R\. " + eachClothItemRecord.product_price.toString(), 
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange.shade900,),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(eachClothItemRecord.product_image!)),
                                        )
                                    ),
                                    ]
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ), 
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        }
    );
  }

   Future<List<Clothes>> getTrendingClothItems() async
  {
    List<Clothes> trendingClothItemsList = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.getTrendingMostPopularClothes)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfTrending = jsonDecode(res.body);
        if(responseBodyOfTrending["success"] == true)
        {
          (responseBodyOfTrending["clothItemsData"] as List).forEach((eachRecord)
          {
            trendingClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return trendingClothItemsList;
  }

   Future<List<Clothes>> getAllClothItems() async
  {
    List<Clothes> allClothItemsList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getAllClothes)
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if(responseBodyOfAllClothes["success"] == true)
        {
          (responseBodyOfAllClothes["clothItemsData"] as List).forEach((eachRecord)
          {
            allClothItemsList.add(Clothes.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allClothItemsList;
  }

}
