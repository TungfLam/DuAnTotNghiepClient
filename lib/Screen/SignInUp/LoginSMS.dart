// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/loading.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:appclient/services/firebaseAuthService.dart';
import 'package:appclient/services/firebaseMessagingService.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginSMS extends StatefulWidget {
  const LoginSMS({Key? key, required this.title}) : super(key: key);
  final String title;

  static const nameLoginSMS = "/loginsms";

  @override
  State<LoginSMS> createState() => _LoginState();
}

class _LoginState extends State<LoginSMS> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();
  final TextEditingController _phone = TextEditingController();
  bool _isLoading = false;

  Future<void> _callLoginPhone(BuildContext context , String phone) async{
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
        Uri.parse("$BASE_API/api/usersloginphone"),
        headers: <String , String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String , String>{
          'Phone' : phone,
        })
    );

    if(response.statusCode == 200){
      Map<String , dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }else{
        String deviceId = await _authService.getDeviceId(context);
        String token = await _messagingService.getToken();

        bool statusToken = await setToken(context , res.idUser.toString() , token , deviceId);

        if(statusToken){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("idUser", res.idUser.toString());
          await prefs.setString("role", res.role.toString());
          await prefs.setString("avata", res.avata.toString());
          await prefs.setString("phone", res.phone.toString());
          await prefs.setString("email", res.email.toString());
          await prefs.setString("fullname", res.fullname.toString());
          await prefs.setString("address", res.address.toString());
          await prefs.setString("address_city", res.addressCity.toString());
          await prefs.setString("specific_addres", res.specificAddres.toString());
          await prefs.setBool("isLogin", true);

          if(phone.startsWith("0")){
            phone = phone.substring(1);
          }else if(phone.startsWith("+84")){
            phone = phone.substring(3);
          }
          phone = "+84$phone";
          await _authService.signInWithPhone(phone, true, context);
        }else{
          showSnackBarErr(context, "Đăng nhập thất bại");
        }
      }
    }else {
      showSnackBarErr(context, "Lỗi server,vui lòng thử lại sau");
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 350,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/images/background.png'),
                            fit: BoxFit.fill)),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 500),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'lib/images/light-1.png'))),
                              )),
                        ),
                        Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'lib/images/light-2.png'))),
                              )),
                        ),
                        Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 800),
                              child: Container(
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                        AssetImage('lib/images/clock.png'))),
                              )),
                        ),
                        Positioned(
                          child: FadeInUp(
                              duration: const Duration(milliseconds: 1100),
                              child: Container(
                                margin: const EdgeInsets.only(top: 80),
                                child: const Center(
                                  child: Text(
                                    "Adadas\n   Xin Chào",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                    controller: _phone,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        labelText: "Số điện thoại",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        prefixIcon: const Icon(Icons.phone)),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 64,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: CustomButton(text: "Đăng nhập", onPressed: (){
                              _clickLogin(context);
                            })
                        ),
                        const SizedBox(height: 16),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: CustomButtonOutline(text: "Dăng nhập bằng email,ussername", onPressed: (){
                              Navigator.pop(context);
                            })
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 70,
                              ),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: const Text(
                                    "Bạn không có tài khoản?\t",
                                    style: TextStyle(color: Colors.grey),
                                  )),
                              FadeInUp(
                                  duration: const Duration(milliseconds: 1500),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/register');
                                    },
                                    child: const Text(
                                      "Tạo tải khoản",
                                      style: TextStyle(
                                          color: Color(0xFF6342E8)),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            _isLoading ? const showLoading() : const SizedBox()
          ],
        )
    );
  }

  void _clickLogin(BuildContext context){
    String sPhone = _phone.text;
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);

    if(sPhone.isEmpty){
      showSnackBarErr(context, "Vui lòng nhập số điện thoại");
    }else if(!regExp.hasMatch(sPhone)) {
      showSnackBarErr(context, "Số điện thoại không đúng định dạng");
    }else{
      _callLoginPhone(context, sPhone);
    }
  }
}
