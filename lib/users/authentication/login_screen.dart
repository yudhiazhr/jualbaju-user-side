import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pi_app/Screens/home_screen.dart';
import 'package:pi_app/users/authentication/signup_screen.dart';
import '../../api_connection/api_connection.dart';
import '../../widgets/mybutton.dart';
import '../../widgets/mytextformfield.dart';
import '../../widgets/passwordtextformfield.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';
import '../userPreferences/user_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obserText=true;

  loginUserNow() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.login),
        body: {
          "user_email": emailController.text.trim(),
          "user_password": passwordController.text.trim(),
        },
      );

      if(res.statusCode == 200) 
      {
        var resBodyOfLogin = jsonDecode(res.body);
        if(resBodyOfLogin['success'] == true)
        {
          Fluttertoast.showToast(msg: "you are logged-in Successfully.");
          User userInfo = User.fromJson(resBodyOfLogin["userData"]);
          await RememberUserPrefs.storeUserInfo(userInfo);
          Future.delayed(Duration(milliseconds: 2000), ()
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );   
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Incorrect Credentials.\nPlease write correct password or email and Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        bottomNavigationBar: Container(
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Dont Have An Account? ", style: TextStyle(fontSize: 14,color: Colors.white),),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => SignUpScreen());
                              },
                              
                              child: Text("Sign Up", style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color: Colors.yellow.shade800),),
                              ),
                          ],
                        ) ,
                      height: 70,
                      width: double.infinity,
                      decoration:BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(topLeft: Radius.elliptical(400, 80), topRight: Radius.elliptical(400, 80)),
                        
                      ),
                      ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(height: 60,),
                Text("Welcome", style: TextStyle(fontSize: 18,),),
                Text("Happy Shopping", style: TextStyle(fontSize: 32,),),
                SizedBox(height: 35,),
                Text("Login", style: TextStyle(fontSize: 32,),),
                SizedBox(height: 20,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                  ),
                  child: Column(
                    children: <Widget>[
                    MyTextFormField(
                      controller: emailController, 
                      name: "Email", 
                      prefixIcon: Icon(Icons.email_rounded), 
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
                          emailController.text = value!;
                          },
                        ),
                      
                        SizedBox(height: 10),
      
                      
                      PasswordTextFormField(
                        controller: passwordController, 
                        name: "Password",
                        prefixIcon: Icon(Icons.lock_rounded),
                        obserText: obserText, 
                        onTap: () {
                            setState(() {
                              obserText =!obserText;
                            });
                        } ,
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
                            passwordController.text = value!;
                          },
                        ),
                        SizedBox(height: 30,),

                        MyButton(
                          name: "Login", 
                          onPressed: () {
                            if(_formKey.currentState!.validate()) {
                              loginUserNow();
                            }
                          }
                          ),
                          SizedBox(height: 10,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}