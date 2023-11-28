import 'dart:convert';

import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:appclient/services/firebaseAuthService.dart';
import 'package:appclient/services/firebaseMessagingService.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  Future<void> _callLogin(BuildContext context , String username , String password) async{
    final response = await http.post(
      Uri.parse("$BASE_API/api/userslogin"),
      headers: <String , String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String , String>{
        'Username' : username,
        'Password' : password
      })
    );

    if(response.statusCode == 200){
      Map<String , dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if(res.err!){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.msg!, style: const TextStyle(color: Colors.white) ),
            backgroundColor: Colors.red,
          ),
        );
      }else{
        String deviceId = await _authService.getDeviceId(context);
        String token = await _messagingService.getToken();

        bool statusToken = await setToken(context , res.idUser.toString() , token , deviceId);

        if(statusToken){
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("idUser", res.idUser.toString());
          await prefs.setString("role", res.role.toString());
          await prefs.setBool("isLogin", true);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.msg!, style: const TextStyle(color: Colors.white) ),
              backgroundColor: Colors.green,
            ),
          );
          await Navigator.pushReplacementNamed(context,"/");
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Đăng nhập thất bại", style: TextStyle(color: Colors.white) ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> setToken(BuildContext context , String idUser , String token , String deviceId) async {
    final response = await http.put(
        Uri.parse("$BASE_API/api/setoken/$idUser"),
        headers: <String , String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String , String>{
          'token' : token,
          'deviceId' : deviceId,
        })
    );

    if(response.statusCode == 200){
      Map<String , dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if(res.err!){
        print("err : set Token thất bại : ${res.msg}");
        return false;
      }else{
        if(res.msg == "đăng nhập thiết bị 2"){
          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Thông báo"),
                  content: const Text("Tài khoản đã đăng nhập ở nơi khác"),
                  actions: [
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK")
                    )
                  ],
                );
              }
          );
        }
        return true;
      }
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
                                controller: _username,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    labelText: "Tài khoản",
                                    hintText: "Sdt/email/username",
                                    hintStyle: const TextStyle(color: Colors.black26),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefixIcon: const Icon(Icons.person)),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: _password,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                    labelText: "Mật khẩu",
                                    hintText: "password",
                                    hintStyle: const TextStyle(color: Colors.black26),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    prefixIcon: const Icon(Icons.lock)),
                              ),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: const Text("Quên mật khẩu?",
                                style: TextStyle(
                                  color: Color.fromRGBO(3, 15, 243, 0.973),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            _clickLogin(context);
                            },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF6342E8), // Đặt màu nền
                          ), child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ));
  }

  void _clickLogin(BuildContext context){
    String username = _username.text;
    String password = _password.text;

    if(username.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập tài khoản", style: TextStyle(color: Colors.white) ),
          backgroundColor: Colors.red,
        ),
      );
    }else if(password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng nhập mật khẩu", style: TextStyle(color: Colors.white) ),
          backgroundColor: Colors.red,
        ),
      );
    }else{
      setState(() {
        _isLoading = true;
      });
      _callLogin(context , username , password);
    }
  }
}
