import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PushService {
  static final _messaging = FirebaseMessaging.instance;

  static Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint('[background] ${message.messageId}: ${message.notification?.body}');
  }

  static Future init() async {

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    debugPrint('Permiso notificaciones: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);

    String? token = await _messaging.getToken();
    debugPrint('FCM Token: $token');

    FirebaseMessaging.onMessage.listen((RemoteMessage msg) {
      debugPrint('[foreground] ${msg.notification?.title}: ${msg.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage msg) {
      debugPrint('[onOpen] datos: ${msg.data}');

    });
  }
}
