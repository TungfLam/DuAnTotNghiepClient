
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> configureLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("mipmap/ic_launcher");
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  Future<void> onSelectNotification(String payload) async {
    // Giải mã payload để lấy ID sản phẩm
    Map<String, dynamic> data = jsonDecode(payload);
    String productId = data['productId'];

    // Điều hướng đến trang chi tiết sản phẩm
    // Navigator.pushNamed(context, '/product/$productId');
  }

}

Future<void> showNotification(String title , String content) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    "du_an_to_nghiep_notifcation_service_0393267599",
    "Adadas Notification",
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics
  );

  await flutterLocalNotificationsPlugin.show(
      0,
      title,
      content,
      platformChannelSpecifics
  );
}