import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBoxScreen extends StatefulWidget {
  const ChatBoxScreen({super.key});

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  String anhdd = '';
  String mail = '';
  String fname = '';
  String userid = '';//id user

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    final String? avarta = prefs.getString("avata");
    final String? email = prefs.getString("email");
    final String? fullname = prefs.getString("fullname");
    print('$idUser');

    setState(() {
      userid = idUser ?? '';
      anhdd = avarta ?? '';
      mail = email ?? '';
      fname = fullname ?? '';
    });

    if (isLogin == null) {
      return;
    }

    if (isLogin) {
      // sử lý khi đã đăng nhập
    } else {
      // sử lý khi chưa đăng nhập
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text('iduser: $userid')),
      ),
    );
  }
}
