import 'package:appclient/Screen/BannerScreen.dart';
import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/Screen/Favorite.dart';
import 'package:appclient/Screen/Find.dart';
import 'package:appclient/Screen/Login.dart';
import 'package:appclient/Screen/LoginOrRegister.dart';
import 'package:appclient/Screen/MyCart.dart';
import 'package:appclient/Screen/MyHomePage.dart';
import 'package:appclient/Screen/Register.dart';
import 'package:appclient/services/local_notification.dart';
import 'package:appclient/services/socket_io.dart';
import 'package:flutter/material.dart';
<<<<<<< Updated upstream

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureLocalNotifications();
  connectSocket();
=======
  
void main() {
>>>>>>> Stashed changes
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
        '/find': (context) => const Find(title: ''),
        '/favorite': (context) => const Favorite(title: ''),
        '/detaiproduct': (context) => const DetailProduct(title: ''),
        // Đăng ký đường dẫn cho màn hình MyCart
      },
    );
  }
}
