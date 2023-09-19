import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:pi_app/users/authentication/login_screen.dart';
import 'package:pi_app/users/model/user.dart';
import '../../api_connection/api_connection.dart';
import '../../widgets/mybutton.dart';
import '../../widgets/mytextformfield.dart';
import '../../widgets/mytextformfield_ver2.dart';
import '../../widgets/passwordtextformfield.dart';
import 'package:http/http.dart' as http;


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var _formKey = GlobalKey<FormState>();
  var userNameEditingController = TextEditingController();
  var emailEditingController = TextEditingController();
  var passwordEditingController = TextEditingController();
  var streetaddressEditingController = TextEditingController();
  var cityEditingController = TextEditingController();
  var stateEditingController = TextEditingController();
  var zipCodeEditingController = TextEditingController();
  var countryEditingController = TextEditingController();
  var phoneNumberEditingController = TextEditingController();

  bool obserText=true;

  validateUserEmail() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'user_email': emailEditingController.text.trim(),
        },
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
      {
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if(resBodyOfValidateEmail['emailFound'] == true)
        {
          Fluttertoast.showToast(msg: "Email is already in someone else use. Try another email.");
        }
        else
        {
          //register & save new user record to database
          registerAndSaveUserRecord();
        }
      }
      else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async
  {
    User userModel = User(
      /* 1, */
      userNameEditingController.text.trim(),
      emailEditingController.text.trim(),
      passwordEditingController.text.trim(),
      streetaddressEditingController.text.trim(),
      cityEditingController.text.trim(),
      stateEditingController.text.trim(),
      zipCodeEditingController.text.trim(),
      countryEditingController.text.trim(),
      phoneNumberEditingController.text.trim(),
    );

    try
    {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: userModel.toJson(),
      );

      if(res.statusCode == 200) 
      {
        var resBodyOfSignUp = jsonDecode(res.body);
        if(resBodyOfSignUp['success'] == true)
        {
          Fluttertoast.showToast(msg: "Congratulations, you are SignUp Successfully.");

          setState(() {
          userNameEditingController.clear();
          emailEditingController.clear();
          passwordEditingController.clear();
          streetaddressEditingController.clear();
          cityEditingController.clear();
          stateEditingController.clear();
          zipCodeEditingController.clear();
          countryEditingController.clear();
          phoneNumberEditingController.clear();
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Error Occurred, Try Again.");
        }
      }
      else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: TextStyle(fontSize: 14, color: Colors.white),),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => LoginScreen());
                                
                              },
                              child: Text("Login", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.yellow.shade700),),)
                        ],
                      ),
                      height: 70,
                      width: double.infinity,
                      decoration:BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
                        
                      ),
                      ),     
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
              Get.to(() => LoginScreen());
            
          },
        ),
      ),
      
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(  
                padding: EdgeInsets.only(left: 40, right: 40),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text("Sign Up", style: TextStyle(fontSize: 32),)
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    MyTextFormField(
                      controller: userNameEditingController,
                      name: "Name",
                      prefixIcon: Icon(Icons.person_sharp),
                      validator: (value) {
                          RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("User name Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid User name(Min. 3 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          userNameEditingController.text =value!;
                        },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    
                    // EmailField 
                    MyTextFormField(
                      controller: emailEditingController,
                      name: "Email",
                      prefixIcon: Icon(Icons.mail_rounded),
                      validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          if (!RegExp("^[a-zA-z0-9+_.-]+@[[a-zA-z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailEditingController.text = value!;
                        },
                      ),

                    SizedBox(
                      height: 10,
                    ),

                    // PasswordField
                    PasswordTextFormField(
                      controller: passwordEditingController,
                      name: "Password", 
                      prefixIcon: Icon(Icons.lock_rounded),
                      onTap: () {
                        setState(() {
                            obserText =!obserText;
                          });
                        }, 
                    
                      obserText: obserText, 
                      validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          passwordEditingController.text = value!;
                        },
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //Street address
                    MyTextFormField(
                      controller: streetaddressEditingController, 
                      name: "Street address and subdistrict", 
                      prefixIcon: Icon(Icons.streetview_rounded), 
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("Street Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Street Cannot Be Empty");
                          }
                          return null;
                      }, 
                      onSaved: (value) {
                        streetaddressEditingController.text = value!;
                      }),
                      SizedBox(
                      height: 10,
                    ),
                    
                    //City Field
                    MyTextFormField(
                      controller: cityEditingController, 
                      name: "City", 
                      prefixIcon: Icon(Icons.location_city_rounded), 
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("City Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("City Cannot Be Empty");
                          }
                          return null;
                      }, 
                      onSaved: (value) {
                        cityEditingController.text = value!;
                      }),
                      SizedBox(
                      height: 10,
                    ),

                    //StateField
                     MyTextFormField(
                      controller: stateEditingController, 
                      name: "State / Province / Region", 
                      prefixIcon: Icon(Icons.location_city_rounded), 
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("State / Province / Region Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("State / Province / Region Cannot Be Empty");
                          }
                          return null;
                      }, 
                      onSaved: (value) {
                        stateEditingController.text = value!;
                      }),
                      SizedBox(
                      height: 10,
                    ),

                    //Zip code
                     MyTextFormField(
                      controller: zipCodeEditingController, 
                      name: "Zip code", 
                      prefixIcon: Icon(Icons.location_on_outlined), 
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{5,}$');
                          if (value!.isEmpty) {
                            return ("Zip code Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid zip code (Min. 5 Character)");
                          }
                          return null;
                      }, 
                      onSaved: (value) {
                        zipCodeEditingController.text = value!;
                      }),
                      SizedBox(
                      height: 10,
                    ),
                    
                    //Country field
                     MyTextFormField(
                      controller: countryEditingController, 
                      name: "Country", 
                      prefixIcon: Icon(Icons.location_on_outlined), 
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("Country Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Country Cannot Be Empty");
                          }
                          return null;
                      }, 
                      onSaved: (value) {
                        countryEditingController.text = value!;
                      }),
                      SizedBox(
                      height: 10,
                    ),

                    // PhoneNumberField
                    MyTextFormField(
                      controller: phoneNumberEditingController,
                      name: "Phone number",
                      prefixIcon: Icon(Icons.phone), 
                      validator: (value) {
                        RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{11,12}$)');
                        if(value!.isEmpty) {
                          return "Phone Number Cannot Be Empty";
                        } else if (!regex.hasMatch(value)) {
                          return 'Please Enter Valid Phone Number (Min. 11 Character)';
                        }
                        return null;
                        },
                        onSaved: (value) {
                          phoneNumberEditingController.text = value!;
                        },
                      ),
        
                    SizedBox(height: 20),

                    MyButton(name: "Sign up", onPressed: () {
                     /*  validation(emailEditingController.text, passwordEditingController.text); */
                     if(_formKey.currentState!.validate()) {
                      validateUserEmail();
                     }
                    }),

                    SizedBox(height: 10),
                    
                  ],
                ),
              ),
              ),
               
            ],
          ),
        ),
      ),
    );
  }
}