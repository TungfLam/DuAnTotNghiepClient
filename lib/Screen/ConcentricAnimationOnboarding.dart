import 'package:appclient/Screen/BannerScreen.dart';
import 'package:appclient/Screen/SignInUp/Login.dart';
import 'package:appclient/Screen/LoginOrRegister.dart';
import 'package:appclient/Screen/MyHomePage.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

final pages = [
  const PageData(

    bgColor: Color(0xff9975ff),
    textColor: Color(0xff3b1790),
  ),
  const PageData(

    bgColor: Color(0xFFc2cbdc),
    textColor: Color(0xff3b1790),
  ),
];

class ConcentricAnimationOnboarding extends StatelessWidget {
  const ConcentricAnimationOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Do nothing when tapped
        },
        child: ConcentricPageView(
          colors: pages.map((p) => p.bgColor).toList(),
          radius: screenWidth * 0.1,
          nextButtonBuilder: null,
          scaleFactor: 2,
          itemBuilder: (index) {
            if (index == 0) {
              return BannerScreen(title: '');
            } else if (index == 1) {
              return LoginOrRegister(title: '');
            } else {
              // You can handle additional pages here
              return MyHomePage(title: '');
            }
          },
        ),
      ),
    );
  }
}



class PageData {
  final String? title;
  final IconData? icon;
  final Color bgColor;
  final Color textColor;

  const PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}
