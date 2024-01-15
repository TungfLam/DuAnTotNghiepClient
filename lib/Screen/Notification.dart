// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Widgets/itemNotification.dart';
import 'package:appclient/Widgets/loading.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/Notification_Model.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() => NotificationPage();
}

class NotificationPage extends State<NotificationScreen> {
  List<NotificationM> listNotification = [];
  String idUser = '';
  bool isLoading = false;

  Future<void> getNotifications() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      idUser = prefs.getString("idUser")!;
    }catch(e){
      showSnackBarErr(context, "Vui lòng đăng nhập để xem thông báo");
      Navigator.pop(context);
      return;
    }

    final response = await http.get(
        Uri.parse("$BASE_API/api/notification/$idUser")
    );

    if(response.statusCode == 200){
      final data = await jsonDecode(response.body) as List;
      listNotification = data.map((e) => NotificationM.fromJson(e)).toList();

    }else{
      showSnackBarErr(context, "Lỗi server, vui lòng thử lại sau");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Thông báo',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              // Handle the back button press here, such as navigating back
              Navigator.of(context).pop();
            },
          ),
          elevation: 0.5,
        ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: listNotification.map((e) => itemNotification(notification: e)).toList(),
              ),
            ),
          ),

          isLoading ? const showLoading() : const SizedBox()
        ]
      ),
    );
  }
}