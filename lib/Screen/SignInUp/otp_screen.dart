// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:appclient/Screen/SignInUp/RegisterScreen2.dart';
import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/countDown.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/toSendCode.dart';
import 'package:appclient/services/firebaseAuthService.dart';
import 'package:appclient/services/firebaseMessagingService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

// ignore: camel_case_types
class Otp_Screen extends StatefulWidget{
  static const nameOtp = "/otp_screen";

  const Otp_Screen({super.key});

  @override
  State<Otp_Screen> createState() => _Otp_ScreenState();
}

// ignore: camel_case_types
class _Otp_ScreenState extends State<Otp_Screen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final toSendCode verificationphone = ModalRoute.of(context)!.settings.arguments as toSendCode;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children:[
            Container(
              height: 350,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/images/background.png'),
                      fit: BoxFit.fill)),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'lib/images/light-1.png'))),
                        )),
                  ),
                  Positioned(
                    right: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'lib/images/light-2.png'))),
                        )),
                  ),
                  Positioned(
                    left: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(image: AssetImage('lib/images/clock.png'))),
                      )),
                  ),
                  Positioned(
                    child: FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 200),
                              child: const Center(
                                child: Text(
                                  "Xác minh OTP",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: Center(
                                child: Text(
                                  "Đã gửi mã otp đến số ${verificationphone.phone}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]
                        )),
                  ),
                ],
              ),
            ),
            const countDown(countX: 60),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.only(right: 8 , left: 8),
              padding: const EdgeInsets.only(right: 16 , left: 16),
              child: Pinput(
                length: 6,
                showCursor: true,
                onCompleted: (value){
                  setState(() {
                    otpCode = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            Container(
              margin: const EdgeInsets.only(right: 24 , left: 24),
              child: CustomButton(text: "Xác nhận", onPressed: () {
                if(otpCode != null){
                  if(verificationphone.isLogin!){
                    verifyOtpSignIn(context , verificationphone.verificationId.toString(), otpCode!);
                  }else{
                    verifyOtpSignUp(context , verificationphone.verificationId.toString(), otpCode! , verificationphone.phone.toString());
                  }
                }else {
                  showSnackBarErr(context, "Vui lòng nhập đủ mã OTP");
                }
              }),
            )
          ]
        ),
      ),
    );
  }
  Future<void> verifyOtpSignUp (BuildContext context , String verificationId, String otpc , String phone) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpc
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.of(context).pushNamed(RegisterScreen2.nameRegiterScree2 , arguments: phone);
    print("danh ky sdt thanh cong");
  }

  Future<void> verifyOtpSignIn(BuildContext context , String verificationId, String otpc) async {
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otpc
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      await Navigator.pushReplacementNamed(context,"/");
    }catch(e){
      showSnackBarErr(context, "Xác minh otp thât bại");
    }
  }
}

