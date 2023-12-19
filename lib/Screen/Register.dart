// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:appclient/services/firebaseAuthService.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final FirebaseAuthService authService = FirebaseAuthService();
  final TextEditingController _phoneController = TextEditingController();

  Future<bool> _chekPhone(BuildContext context , String phone) async{
    final response = await http.post(
        Uri.parse("https://adadas.onrender.com/api/usersloginphone"),
        headers: <String , String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String , String>{
          'Phone' : phone,
        })
    );

    if(response.statusCode == 200){
      print("200");
      Map<String , dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if(res.err!){
        print("check");
        if(res.msg! == "Số điện thoại chưa đăng ký"){
          print("thanh cong");
          return true;
        }
      }
    }else{
      print("err sv : ${response.statusCode}");
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
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
                        duration: const Duration(seconds: 1),
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
                          duration: const Duration(milliseconds: 1200),
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
                          duration: const Duration(milliseconds: 1300),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('lib/images/clock.png'))),
                          )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 110),
                            child: const Center(
                              child: Text(
                                "Bắt đầu mua hàng với Adadas",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
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
                        duration: const Duration(milliseconds: 1800),
                        child: Container(
                          padding: const EdgeInsets.all(4.8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: "Số điện thoại",
                                    hintText: "+84",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.phone)),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 50),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1900),
                      child: CustomButton(text: "Đăng ký", onPressed: () async {
                        _clickSignUp(context);
                      })
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 80,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: const Text(
                              "Bạn đã có tài khoản?\t",
                              style: TextStyle(color: Colors.grey),
                            )),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Đăng nhập",
                                style: TextStyle(color: Color(0xFF6342E8)),
                              ),
                            ))
                          ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _clickSignUp(BuildContext context) async{
    String sPhone = _phoneController.text.trim();
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if(sPhone.isEmpty){
      showSnackBarErr(context, "Vui lòng nhập số điện thoại");
    }else if(!regExp.hasMatch(sPhone)){
      showSnackBarErr(context, "Số điện thoại không hợp lệ");
    }else{
      if(await _chekPhone(context, sPhone)){
        if(sPhone.startsWith("0")){
          sPhone = sPhone.substring(1);
        }else if(sPhone.startsWith("+84")){
          sPhone = sPhone.substring(3);
        }
        sPhone = "+84$sPhone";
        authService.signInWithPhone(sPhone , false, context);
      }else{
        showSnackBarErr(context, "Số điện thoại đã đăng ký");
      }
    }
  }
}
