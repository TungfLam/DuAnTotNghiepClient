import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/Screen/Favorite.dart';
import 'package:appclient/Screen/Find.dart';
import 'package:appclient/Screen/Login.dart';
import 'package:appclient/Screen/MyCart.dart';
import 'package:appclient/Screen/MyHomePage.dart';
import 'package:appclient/Screen/Register.dart';
import 'package:appclient/Screen/Welcome.dart';
import 'package:flutter/material.dart';

void main() {
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
      initialRoute: '/register', // Đường dẫn mặc định khi khởi chạy ứng dụng
      routes: {
        '/register': (context) => const Register(title: ''),

        '/login': (context) => const Login(title: ''),

        '/welcome': (context) => const Welcome(title: ''),
        '/': (context) => const MyHomePage(title: ''),
        '/mycart': (context) => const MyCart(title: ''),
        '/find': (context) => const Find(title: ''),
        '/favorite': (context) => const Favorite(title: ''),
        '/detaiproduct': (context) => const DetailProduct(title: ''), 
        // Đăng ký đường dẫn cho màn hình MyCart
      },
    );
  }
}
