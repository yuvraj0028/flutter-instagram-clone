import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/constants.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackGroundMessage(RemoteMessage message) async {
    debugPrint('backGroundMessage');
  }

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.setAutoInitEnabled(true);
      await _firebaseMessaging.requestPermission();
      final fcmToken = await _firebaseMessaging.getToken();

      await FirebaseMessaging.instance.subscribeToTopic("all");

      debugPrint(fcmToken);
      initPushNotifications();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    debugPrint('inHandleMessage');
  }

  Future initPushNotifications() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> sendFcmMessage(String title, String message) async {
    try {
      var url = baseUrl;
      var header = {
        "Content-Type": "application/json",
        "Authorization": "key= $keyServer",
      };

      var request = {
        "notification": {
          "title": title,
          "body": message,
        },
        "to": "/topics/all",
      };

      await http.post(
        Uri.parse(url),
        headers: header,
        body: json.encode(request),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}
