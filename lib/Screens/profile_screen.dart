import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pi_app/Screens/home_screen.dart';
import 'package:pi_app/users/userPreferences/current_user.dart';
import '../api_connection/api_connection.dart';
import '../users/authentication/login_screen.dart';
import '../users/model/user.dart';
import '../users/userPreferences/user_preferences.dart';
import '../widgets/profilelisttile.dart';
import 'cart/cart_list_screen.dart';
import 'edit_profile_screen.dart';
import 'ordersOnProcess_screen.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure?\nyou want to logout from app?",
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
          TextButton(
              onPressed: () {
                Get.back(result: "loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              )),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(() => LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _currentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.to(() => HomeScreen());
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              "https://static-00.iconduck.com/assets.00/person-icon-2048x2048-wiaps1jt.png"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    _currentUser.user.user_name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _currentUser.user.user_email,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_currentUser.user.user_id_phone_number),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _currentUser.user.user_street_address +  ", " + _currentUser.user.user_city +
                                      ", " +
                                      _currentUser.user.user_state +
                                      ", " +
                                      _currentUser.user.user_country +
                                      ", " +
                                      _currentUser.user.user_zipcode,
                                  maxLines: 10,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.black,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        User updatedUser = _currentUser.user;
                                        return AlertDialog(
                                          title: Text("Update Profile"),
                                          content: SingleChildScrollView(
                                            controller: ScrollController(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user.user_name,
                                                  onChanged: (value) {
                                                    _currentUser
                                                        .user.user_name = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "Name"),
                                                ),
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user.user_street_address,
                                                  onChanged: (value) {
                                                    _currentUser.user
                                                            .user_street_address =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Street Address"),
                                                ),
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user.user_city,
                                                  onChanged: (value) {
                                                    _currentUser
                                                        .user.user_city = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "City"),
                                                ),
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user.user_state,
                                                  onChanged: (value) {
                                                    _currentUser.user
                                                        .user_state = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "State"),
                                                ),
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user.user_zipcode,
                                                  onChanged: (value) {
                                                    _currentUser.user
                                                        .user_zipcode = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "Zipcode"),
                                                ),
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user.user_country,
                                                  onChanged: (value) {
                                                    _currentUser.user
                                                        .user_country = value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "Country"),
                                                ),
                                                TextFormField(
                                                  initialValue: _currentUser
                                                      .user
                                                      .user_id_phone_number,
                                                  onChanged: (value) {
                                                    _currentUser.user
                                                            .user_id_phone_number =
                                                        value;
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Phone Number"),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                bool isSuccess =
                                                    await updateProfile(
                                                        updatedUser);
                                                if (isSuccess) {
                                                  setState(() {
                                                    _currentUser
                                                            .user.user_name =
                                                        updatedUser.user_name;
                                                    _currentUser.user
                                                            .user_street_address =
                                                        updatedUser
                                                            .user_street_address;
                                                    _currentUser
                                                            .user.user_city =
                                                        updatedUser.user_city;
                                                    _currentUser
                                                            .user.user_state =
                                                        updatedUser.user_state;
                                                    _currentUser
                                                            .user.user_zipcode =
                                                        updatedUser
                                                            .user_zipcode;
                                                    _currentUser
                                                            .user.user_country =
                                                        updatedUser
                                                            .user_country;
                                                    _currentUser.user
                                                            .user_id_phone_number =
                                                        updatedUser
                                                            .user_id_phone_number;
                                                  });
                                                }
                                              },
                                              child: Text("Update"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Edit"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ProfileListTile(
                      icon: Icons.card_giftcard_rounded,
                      title: "Orders",
                      onTap: () {
                        Get.to(() => OrdersOnProcessScreen());
                      }),
                  ProfileListTile(
                      icon: Icons.exit_to_app_rounded,
                      title: "Logout",
                      onTap: () {
                        signOutUser();
                      }),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ver Beta",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(400, 80),
                    topRight: Radius.elliptical(400, 80)),
              ),
            ),
          );
        });
  }

  Future<bool> updateProfile(User user) async {
    try {
      var res = await http.post(
        Uri.parse(API.updateDataUser),
        body: {
          "user_name": user.user_name,
          "user_street_address": user.user_street_address,
          "user_city": user.user_city,
          "user_state": user.user_state,
          "user_zipcode": user.user_zipcode,
          "user_country": user.user_country,
          "user_id_phone_number": user.user_id_phone_number,
        },
      );

      if (res.statusCode == 200) {
        var responseBody = jsonDecode(res.body);

        if (responseBody["success"] == true) {
          Fluttertoast.showToast(msg: "Update profile successful");

          _currentUser.user.user_name = user.user_name;
          _currentUser.user.user_street_address = user.user_street_address;
          _currentUser.user.user_city = user.user_city;
          _currentUser.user.user_state = user.user_state;
          _currentUser.user.user_zipcode = user.user_zipcode;
          _currentUser.user.user_country = user.user_country;
          _currentUser.user.user_id_phone_number = user.user_id_phone_number;

          setState(() {
            _currentUser.user.user_name = user.user_name;
            _currentUser.user.user_street_address = user.user_street_address;
            _currentUser.user.user_city = user.user_city;
            _currentUser.user.user_state = user.user_state;
            _currentUser.user.user_zipcode = user.user_zipcode;
            _currentUser.user.user_country = user.user_country;
            _currentUser.user.user_id_phone_number = user.user_id_phone_number;
          });
          updateUserInfo();

          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to update profile");
          return false;
        }
      } else {
        Fluttertoast.showToast(msg: "Error, Status Code is not 200");
        return false;
      }
    } catch (errorMessage) {
      print("Error: $errorMessage");
      Fluttertoast.showToast(msg: "Error: $errorMessage");
      return false;
    }
  }

  void updateUserInfo() {
    RememberUserPrefs.updateUserInfo(_currentUser.user).then((value) {
      Get.off(() => ProfileScreen());
    });
  }
}
