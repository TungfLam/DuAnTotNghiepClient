// ignore_for_file: use_build_context_synchronously, constant_identifier_names

import 'dart:convert';

import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String BASE_API = "http://192.168.2.101:6868";
// http://192.168.2.112:6868
// https://adadas.onrender.com

// Duy : http://192.168.2.102:6868


Future<bool> setToken(
    BuildContext context, String idUser, String token, String deviceId) async {
  final response = await http.put(Uri.parse("$BASE_API/api/setoken/$idUser"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'token': token,
        'deviceId': deviceId,
      }));

  if (response.statusCode == 200) {
    Map<String, dynamic> apiRes = jsonDecode(response.body);
    ApiRes res = ApiRes.fromJson(apiRes);

    if (res.err!) {
      showSnackBarErr(context, "thất bại : ${res.msg}");
      return false;
    } else {
      if (res.msg == "đăng nhập thiết bị 2") {
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Thông báo"),
                content:
                    const Text("Tài khoản đã đăng nhập ở nơi khác , tiếp tục"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              );
            });
      }
      return true;
    }
  }
  return false;
}
