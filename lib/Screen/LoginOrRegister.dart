import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

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
            color: Color(0xFFc2cbdc),
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
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              'Đăng Nhập',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Text('hoặc',style: TextStyle(color: Color(0xFF7b8794)),),
                        // Container(
                        //   margin: EdgeInsets.only(top: 5),
                        //   width: 200,
                        //   height: 50,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(width: 2, color: Colors.white),
                        //     borderRadius: BorderRadius.all(Radius.circular(25)),
                        //   ),
                        //   child: TextButton(
                        //     onPressed: () {
                        //       Navigator.pushNamed(context, '/register');
                        //     },
                        //     child: Text(
                        //       'Đăng ký',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
