import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmail(String email , String password) async {
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print(e);
    }
    return null;
  }

  Future<User?> signInWithEmail(String email , String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e){
      print(e);
    }
    return null;
  }

  Future<User?> signInWithPhone(String phone) async {

    try{
      // UserCredential credential = await _auth.signInWithPhoneNumber();
    }catch(e){
      print(e);
    }

    return null;
  }

  Future<User?> signUpWithPhone(String phone) async {

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