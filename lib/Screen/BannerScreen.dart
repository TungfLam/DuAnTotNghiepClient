
import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

    Future<void> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    if (isLogin != null) {
      if (isLogin == true) {
        print("người dùng đã login");
        Navigator.pushNamed(context, '/');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xff9975ff),
          ),
          child: SlideTransition(
            position: _offsetAnimation,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('lib/images/banner.png'),
                fit: BoxFit.cover,
              )),
              child: SlideTransition(
                position: _offsetAnimation,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: Text(
                            "Adadas",
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/');
                            },
                            child: Text(
                              'Xem ngay',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

