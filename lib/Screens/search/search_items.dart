import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pi_app/Screens/product_detail_screen.dart';

import '../../api_connection/api_connection.dart';
import '../../users/model/clothes.dart';
import '../cart/cart_list_screen.dart';
import '../profile_screen.dart';

import 'package:http/http.dart' as http;


class SearchItems extends StatefulWidget {
  
  final String? typedKeyWords;

  SearchItems({
    this.typedKeyWords
    });

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {

  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> readSearchRecordsFound() async
  {
    List<Clothes> clothesSearchList = [];

    if(searchController.text != "")
    {
      try
      {
        var res = await http.post(
            Uri.parse(API.searchItems),
            body:
            {
              "typedKeyWords": searchController.text,
            }
        );

        if (res.statusCode == 200)
        {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true)
          {
            (responseBodyOfSearchItems['itemsFoundData'] as List).forEach((eachItemData)
            {
              clothesSearchList.add(Clothes.fromJson(eachItemData));
            });
          }
        }
        else
        {
          Fluttertoast.showToast(msg: "Status Code is not 200");
        }
      }
      catch(errorMsg)
      {
        Fluttertoast.showToast(msg: "Error:: " + errorMsg.toString());
      }
    }

    return clothesSearchList;
  }

   @override
  void initState()
  {
    super.initState();

    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: showSearchBarWidget(),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: ()
          {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
          ),
        ),
      ),
      body: searchItemDesignWidget(context),
    );
  }

  Widget showSearchBarWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: TextField(
      style: const TextStyle(color: Colors.black),
      controller: searchController,
      onSubmitted: (value) {
        _performSearch();
      },
      decoration: InputDecoration(
        prefixIcon: IconButton(
          onPressed: () {
            setState(() {});
          },
          icon: Icon(Icons.search_rounded, color: Colors.grey.shade600,),
        ),
        hintText: "Search...",
        suffixIcon: IconButton(
          onPressed: () {
            searchController.clear();
            setState(() {});
          },
          icon: Icon(
            Icons.close,
            color: Colors.grey.shade600,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.only(top: 10),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
  );
}

  void _performSearch() {
    // Call the search function here
    readSearchRecordsFound();
    // Can also close the keyboard after pressing "Enter"
    FocusScope.of(context).unfocus();
  }

   searchItemDesignWidget(context)
  {
    return FutureBuilder(
        future: readSearchRecordsFound(),
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
                        padding: EdgeInsets.all(10),
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

}