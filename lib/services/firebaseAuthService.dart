// ignore_for_file: use_build_context_synchronously

import 'package:appclient/Screen/SignInUp/otp_screen.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/toSendCode.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmail(String email , String password) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      throw Exception(e);
    }
  }

  Future<User?> signInWithEmail(String email , String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> signInWithPhone(String phone , bool isLogin , BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        //
      },
      verificationFailed: (err) async {
        print("that bai r");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        await prefs.setBool("isLogin", false);
        throw Exception(err.message);
      },
      codeSent: (verificationId, [int? forceResendingToken]) {
        toSendCode vphone = toSendCode(verificationId: verificationId , phone: phone , isLogin: isLogin);
        Navigator.of(context).pushNamed(Otp_Screen.nameOtp , arguments: vphone);
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool? isDone = prefs.getBool("isDone");
        print("time out ");
        if(isDone == null || !isDone){
          Navigator.pop(context);
          showSnackBarErr(context, "Mã OTP đã hêt hạn");
          prefs.clear();
        }

      },
      timeout: const Duration(seconds: 12)
    );
  }

  Future<String> getDeviceId(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.androidId.toString();
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor.toString();
    }
    return "";
  }
}