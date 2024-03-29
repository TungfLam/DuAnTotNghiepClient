
import 'package:appclient/Screen/Comment/AllComment.dart';
import 'package:appclient/Screen/BannerScreen.dart';

import 'package:appclient/Screen/ChangePassword.dart';

import 'package:appclient/Screen/ConcentricAnimationOnboarding.dart';

import 'package:appclient/Screen/ConcentricAnimationOnboarding.dart';

import 'package:appclient/Screen/Comment/AddComment.dart';

import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/Screen/Favorite.dart';
import 'package:appclient/Screen/Find.dart';
import 'package:appclient/Screen/Locations/ChangeLocation.dart';
import 'package:appclient/Screen/Locations/Location.dart';
import 'package:appclient/Screen/LoginOrRegister.dart';
import 'package:appclient/Screen/MyCart.dart';
import 'package:appclient/Screen/MyHomePage.dart';
import 'package:appclient/Screen/Notification.dart';
import 'package:appclient/Screen/PayScreen.dart';
import 'package:appclient/Screen/PaymentScreen.dart';
import 'package:appclient/Screen/SignInUp/Login.dart';
import 'package:appclient/Screen/SignInUp/LoginSMS.dart';
import 'package:appclient/Screen/SignInUp/Register.dart';
import 'package:appclient/Screen/SignInUp/RegisterScreen2.dart';
import 'package:appclient/Screen/SignInUp/otp_screen.dart';
import 'package:appclient/Screen/VoucherScreen.dart';
import 'package:appclient/Screen/billAllScreen.dart';
import 'package:appclient/Screen/ChatBoxScreen.dart';

import 'package:appclient/Screen/profile.dart';
import 'package:appclient/services/firebaseMessagingService.dart';
import 'package:appclient/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if(message.notification!.title.toString() == "Messenger"){
    return;
  }
  LocalNotifications2.showNotification(message.notification!.title.toString(), message.notification!.body.toString(), 'item x');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessagingService().initNotifications();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await LocalNotifications2.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),


      initialRoute: '/banner', // Đường dẫn mặc định khi khởi chạy ứng dụng


      routes: {
        '/banner': (context) => const ConcentricAnimationOnboarding(),
        '/': (context) => const MyHomePage(title: ''),
        '/register': (context) => const Register(title: ''),
        '/login': (context) => const Login(title: ''),
        '/loginorregister': (context) => const LoginOrRegister(title: ''),
        '/mycart': (context) => const MyCart(title: ''),
        '/bill': (context) => const BillAllScreen(),
        '/find': (context) => const Find(title: ''),
        '/favorite': (context) => const Favorite(title: ''),
        '/detaiproduct': (context) => const DetailProduct(title: ''),
        '/chat': (context) => const ChatBoxScreen(),
        '/voucher': (context) => const VoucherScreen(),
        '/payment': (context) => const PaymentScreen(),


        Otp_Screen.nameOtp: (context) => const Otp_Screen(),
        LoginSMS.nameLoginSMS: (context) => const LoginSMS(title: ""),
        RegisterScreen2.nameRegiterScree2: (context) => const RegisterScreen2(title: ""),
        AllComment.nameComment: (context) => const AllComment(),
        AddComment.nameAddComment : (context) => const AddComment(),
        ChangeLocation.nameChangeLocation : (context) => const ChangeLocation(),

        '/pay': (context) => const PayScreen(userid: '',  idcart: [], totalAmount: 0, title: '',idDiscount: '',),

        '/notification': (context) => const NotificationScreen(),
        '/location': (context) => const LocationScreen(),

        '/changepassword': (context) => ChangePassword(),
        '/changelocation': (context) => const ChangeLocation(),

        '/profile': (context) => const profileScreen(),
        '/test': (context) => const ConcentricAnimationOnboarding(),

        // Đăng ký đường dẫn cho màn hình MyCart
      },
    );
  }
}
