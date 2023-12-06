import 'package:appclient/Screen/BannerScreen.dart';
import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/Screen/Favorite.dart';
import 'package:appclient/Screen/Find.dart';
import 'package:appclient/Screen/Login.dart';
import 'package:appclient/Screen/LoginOrRegister.dart';
import 'package:appclient/Screen/MyCart.dart';
import 'package:appclient/Screen/MyHomePage.dart';
import 'package:appclient/Screen/PayScreen.dart';
import 'package:appclient/Screen/Register.dart';

import 'package:appclient/Screen/billScreen.dart';


import 'package:flutter/material.dart';

import 'services/local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureLocalNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),


      initialRoute: '/', // Đường dẫn mặc định khi khởi chạy ứng dụng

      routes: {
        '/banner': (context) => const BannerScreen(title: ''),
        '/': (context) => const MyHomePage(title: ''),
        '/register': (context) => const Register(title: ''),
        '/login': (context) => const Login(title: ''),
        '/loginorregister': (context) => const LoginOrRegisterScreen(title: ''),
        '/mycart': (context) => const MyCart(title: ''),
        '/bill': (context) => const BillScreen(),
        '/find': (context) => const Find(title: ''),
        '/favorite': (context) => const Favorite(title: ''),
        '/detaiproduct': (context) => const DetailProduct(title: ''),
        '/pay': (context) => const PayScreen(),
        // Đăng ký đường dẫn cho màn hình MyCart
      },
    );
  }
}
