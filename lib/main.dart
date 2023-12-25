import 'package:appclient/Screen/AllComment.dart';
import 'package:appclient/Screen/BannerScreen.dart';

import 'package:appclient/Screen/ChangeLocation.dart';
import 'package:appclient/Screen/ChangePassword.dart';
import 'package:appclient/Screen/ConcentricAnimationOnboarding.dart'

import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/Screen/Favorite.dart';
import 'package:appclient/Screen/Find.dart';
import 'package:appclient/Screen/Location.dart';
import 'package:appclient/Screen/Login.dart';
import 'package:appclient/Screen/LoginOrRegister.dart';
import 'package:appclient/Screen/LoginSMS.dart';
import 'package:appclient/Screen/MyCart.dart';
import 'package:appclient/Screen/MyHomePage.dart';
import 'package:appclient/Screen/Notification.dart';
import 'package:appclient/Screen/PayScreen.dart';
import 'package:appclient/Screen/Register.dart';
import 'package:appclient/Screen/RegisterScreen2.dart';
import 'package:appclient/Screen/billAllScreen.dart';

import 'package:appclient/Screen/otp_screen.dart';
import 'package:appclient/Screen/profile.dart';
import 'package:appclient/services/firebaseMessagingService.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'services/local_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureLocalNotifications();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessagingService().initNotifications();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(103, 58, 183, 1)),
        useMaterial3: true,
      ),


      initialRoute:
          '/', // Đường dẫn mặc định khi khởi chạy ứng dụng


      routes: {
        '/banner': (context) => const BannerScreen(title: ''),
        '/': (context) => const MyHomePage(title: ''),
        '/register': (context) => const Register(title: ''),
        '/login': (context) => const Login(title: ''),
        '/loginorregister': (context) => const LoginOrRegister(title: ''),
        '/mycart': (context) => const MyCart(title: ''),
        '/bill': (context) => const BillAllScreen(),
        '/find': (context) => const Find(title: ''),
        '/favorite': (context) => const Favorite(title: ''),
        '/detaiproduct': (context) => const DetailProduct(title: ''),


        Otp_Screen.nameOtp : (context) => const Otp_Screen(),
        LoginSMS.nameLoginSMS : (context) => const LoginSMS(title: ""),
        RegisterScreen2.nameRegiterScree2 : (context) => const RegisterScreen2(title: ""),

        AllComment.nameComment : (context) => AllComment(),
        '/pay': (context) => const PayScreen(userid: '',  idcart: [], totalAmount: 0, title: '',),
        '/notification': (context) => const NotificationScreen(),
        '/location': (context) => const LocationScreen(),

        '/changepassword': (context) => ChangePassword(),
        '/changelocation': (context) => ChangeLocation(),


         '/profile': (context) => const profileScreen(),
          '/test': (context) => const ConcentricAnimationOnboarding(),

        // Đăng ký đường dẫn cho màn hình MyCart
      },
    );
  }
}
