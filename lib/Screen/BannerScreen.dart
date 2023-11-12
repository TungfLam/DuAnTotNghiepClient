import 'package:flutter/material.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('lib/images/banner.jpg'),
            fit: BoxFit.cover,
          )),
          child: Container(
              child: Padding(
                  padding: EdgeInsets.only(bottom: 47),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Text(
                          "Adadas",
                          style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                      ),
                      TextButton(
                          child: Text("SHOP NOW".toUpperCase(),
                              style: TextStyle(fontSize: 21)),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.only(
                                      left: 80,
                                      right: 80,
                                      top: 30,
                                      bottom: 30)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      side: BorderSide(
                                          width: 3.0, color: Colors.white)))),
                          onPressed: () => null),
                    ],
                  ))),
        ),
      ),
    );
  }
}
