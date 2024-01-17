import 'dart:convert';

import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/addressModel.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/models/profileModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class profileScreen extends StatefulWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  ObjUser? profile;

  String fullname = '';
  String ava = '';
  String email = '';
  String sdt = '';
  String idaddress = '';
  ObjAddress? address;
  String dc = '';
  String dcct = '';
  final String _inout = "Đăng nhập";

  Future<void> fetchProfile() async {
    // Get user ID from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? idUser = prefs.getString("idUser");

    // Check if the user is logged in
    if (idUser != null) {
      try {
        final response = await http.get(
          Uri.parse(
              '$BASE_API/api/userproflie/$idUser'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData.containsKey('objUser')) {
            final Map<String, dynamic> objUserData = responseData['objUser'];

            // Update the assignment to a single instance
            profile = ObjUser.fromJson(objUserData);

            // Now you can access the profile data using profile?.objUser
            print('API Response Data: ${response.body}');
            print('Username: ${profile?.username}');
            print('Email: ${profile?.email}');
            print('fullname: ${profile?.fullName}');
            print('sdt: ${profile?.phoneNumber}');
            print('idaddress: ${profile?.address}');
            setState(() {
              fullname = profile?.fullName ?? '';
              ava = profile?.avata ?? '';
              email = profile?.email ?? '';
              sdt = profile?.phoneNumber ?? '';
              idaddress = profile?.address ?? '';
            });
            fetchAddresses(profile?.address ?? '');
            // Add other properties as needed
          } else {
            print('Key objUser not found in JSON response');
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error during API call: $e');
      }
    } else {
      // Redirect to the login page if the user is not logged in
      Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> fetchAddresses(String addressid) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_API/api/get-address/$addressid'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('objAddress')) {
          final Map<String, dynamic> objAddressData =
              responseData['objAddress'];
          address = ObjAddress.fromJson(objAddressData);
          print('địa chỉ là: ${address?.specificAddres}');
          setState(() {
            dc = address?.specificAddres ?? '';
            dcct = address?.address ?? '';
          });
        } else {
          print('Key objAddress not found in JSON response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

  Future<bool> logoutUser(String idUser) async {
    final response = await http.post(Uri.parse("$BASE_API/api/logout/$idUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if (res.err!) {
        showSnackBarErr(context, "${res.msg}");
      } else {
        return true;
      }
    } else {
      showSnackBarErr(context, "Lỗi Api");
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'thông tin cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage('$BASE_API$ava'),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFF6342E8),
                        radius: 15,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fullname,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Text(email),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      const Text('Số điện thoại: '),
                      Text(
                        sdt,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                  const Icon(Icons.lock_outline)
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      const Text('Email: '),
                      Text(
                        email,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                  const Icon(Icons.lock_outline)
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      const Text('Địa chỉ: '),
                      Expanded(
                        child: Text(
                          '$dc, $dcct',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )),
                  GestureDetector(
                    onTap: () {
                        Navigator.pushNamed(context, '/location');
                      print('Icon pressed!');
                    },
                    child: Icon(Icons.arrow_right),
                  ),
                ],
              ),
              const SizedBox(
                height: 230,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_inout == "Đăng xuất") {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? idUser = prefs.getString("idUser");
                      await logoutUser(idUser!);
                      prefs.clear();
                      await prefs.setBool("isLogin", false);
                      FirebaseAuth.instance.signOut();
                    }

                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6342E8),
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
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
