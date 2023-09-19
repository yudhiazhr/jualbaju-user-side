import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../api_connection/api_connection.dart';
import '../users/model/user.dart';
import 'package:http/http.dart' as http;

import '../users/userPreferences/current_user.dart';

class EditProfileScreen extends StatefulWidget {
  /* final String user_name;
  final String user_street_address;
  final String user_city;
  final String user_state;
  final String user_zipcode;
  final String user_country;
  final String user_id_phone_number; */

  EditProfileScreen(/* {
    required this.user_name,
    required this.user_street_address,
    required this.user_city,
    required this.user_state,
    required this.user_zipcode,
    required this.user_country,
    required this.user_id_phone_number,
  } */);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _streetAddressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipcodeController;
  late TextEditingController _countryController;
  late TextEditingController _phoneNumberController;

  @override
  void initState() {
    super.initState();
   /*  _nameController = TextEditingController(text: widget.user_name);
    _streetAddressController = TextEditingController(text: widget.user_street_address);
    _cityController = TextEditingController(text: widget.user_city);
    _stateController = TextEditingController(text: widget.user_state);
    _zipcodeController = TextEditingController(text: widget.user_zipcode);
    _countryController = TextEditingController(text: widget.user_country);
    _phoneNumberController = TextEditingController(text: widget.user_id_phone_number); */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: "User Name"),
              controller: _nameController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Street Address"),
              controller: _streetAddressController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "City"),
              controller: _cityController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "State"),
              controller: _stateController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Zip Code"),
              controller: _zipcodeController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Country"),
              controller: _countryController,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Phone Number"),
              controller: _phoneNumberController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                /* User updatedUser = User(
                  user_name: _nameController.text,
                  user_street_address: _streetAddressController.text,
                  user_city: _cityController.text,
                  user_state: _stateController.text,
                  user_zipcode: _zipcodeController.text,
                  user_country: _countryController.text,
                  user_id_phone_number: _phoneNumberController.text,
                );

                bool success = await editProfile(updatedUser);

                if (success) {
                  Fluttertoast.showToast(msg: "Profile updated successfully");
                } else {
                  Fluttertoast.showToast(msg: "Failed to update profile");
                } */
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  final CurrentUser _currentUser = Get.put(CurrentUser());

  Future<bool> updateProfile(User user) async {
  try {
    var res = await http.post(
      Uri.parse(API.updateProduct),
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
}