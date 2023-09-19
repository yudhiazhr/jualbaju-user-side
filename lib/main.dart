import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pi_app/Screens/home_screen.dart';
import 'package:pi_app/users/authentication/login_screen.dart';
import 'package:pi_app/users/userPreferences/user_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey ='pk_test_51NGE2jLqP2nptMgKBaWc1bJ8AKgfNOGtlc8ZofMUs2TecMlpAu3vOGwz4zA4X5uZgQaJbnRxsZPs2dD4WJdBqsBL00XzMuANGn';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      title: 'Arraxys',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: RememberUserPrefs.readUserInfo(),
        builder: (context, dataSnapShot) {
        if(dataSnapShot.data ==  null) {
          return LoginScreen();
        } else {
          return HomeScreen();
        }
      },
      ),
    );
  }
}
