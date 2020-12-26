import 'package:cab_driver/globalvariables.dart';
import 'package:cab_driver/screens/login.dart';
import 'package:cab_driver/screens/mainpage.dart';
import 'package:cab_driver/screens/registration.dart';
import 'package:cab_driver/screens/vehicleinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:151749733936:ios:c1f92dcd0cd00de73887f5',
      apiKey: 'AIzaSyA_FFj58_p33Oy-PGffn7ACD84BI7HmSkE',
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '151749733936',
      databaseURL: 'https://geetaxi-33def-default-rtdb.europe-west1.firebasedatabase.app',
    )
        : FirebaseOptions(
      appId: '1:151749733936:android:dfd195afe6126e0a3887f5',
      apiKey: 'AIzaSyA_FFj58_p33Oy-PGffn7ACD84BI7HmSkE',
      messagingSenderId: '151749733936',
      projectId: 'flutter-firebase-plugins',
      databaseURL: 'https://geetaxi-33def-default-rtdb.europe-west1.firebasedatabase.app',
    ),
  );

  currentFirebaseUser = await FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
      routes: {
        MainPage.id: (context) => MainPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        VehicleInfoPage.id: (context) => VehicleInfoPage(),
        LoginPage.id: (context) => LoginPage(),

      },
    );
  }
}
