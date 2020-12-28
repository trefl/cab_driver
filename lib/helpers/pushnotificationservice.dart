


import 'dart:io';

import 'package:cab_driver/globalvariables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService{

  final FirebaseMessaging fcm = FirebaseMessaging();
  Future initialize() async {

    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        String rideID = message['data']['ride_id'];
        print('ride_id: $rideID');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        String rideID = message['data']['ride_id'];
        print('ride_id: $rideID');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        String rideID = message['data']['ride_id'];
        print('ride_id: $rideID');
      },

    );

  }

  Future<String> getToken() async {
    String token = await fcm.getToken();
    print('token: $token');

    DatabaseReference tokenRef = FirebaseDatabase.instance.reference().child('drivers/${currentFirebaseUser.uid}/token');
    tokenRef.set(token);
    
    fcm.subscribeToTopic('alldrivers');
    fcm.subscribeToTopic('allusers');
  }
}