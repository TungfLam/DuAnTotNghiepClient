import 'package:appclient/Screen/otp_screen.dart';
import 'package:appclient/models/toSendCode.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  //
  Future<void> signInWithPhone(String phone , bool isLogin , BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        // await _auth.currentUser!.reload();
        // if(_auth.currentUser == null){
        //   await _auth.signInWithCredential(phoneAuthCredential);
        // }
        print("thanh cong");
      },
      verificationFailed: (err){
        print("that bai");
        throw Exception(err.message);
      },
      codeSent: (verificationId, [int? forceResendingToken]) {
        toSendCode vphone = toSendCode(verificationId: verificationId , phone: phone , isLogin: isLogin);
        Navigator.of(context).pushNamed(Otp_Screen.nameOtp , arguments: vphone);
        print("send code");
      },
      codeAutoRetrievalTimeout: (verificationId) {

      },
      timeout: const Duration(seconds: 62)
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