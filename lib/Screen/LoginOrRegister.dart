import 'package:flutter/material.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  const LoginOrRegisterScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('lib/images/LoginOrRegister.jpg'),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(
                top: 50,bottom: 80
              ),
              child:  Text(
              "Adadas",
               style: TextStyle(fontSize: 80,fontWeight: FontWeight.w900),
              ), 
              ),
                Text(
              "Create your fashion in your own way",
               style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
              ),
                Padding(padding: EdgeInsets.all(30),
                child:
                Text(
                  "Each men and women has their own style,Adadas help you to create your unique style",
               textAlign: TextAlign.center,
               style: TextStyle(fontWeight: FontWeight.bold),
              ),
                ),

          Container(
            child: Padding(
            padding: EdgeInsets.only(bottom: 47),
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    TextButton(
                child: Text("LOG IN",
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.only(left: 95,right: 95,top: 30,bottom: 30)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide( width:3.0,color: Colors.black)))),
                onPressed: () => null),
                  Padding(padding: EdgeInsets.only(bottom: 20,top: 20),
                    child: Row(
                      children: [
                        Text(
                      "OR",
                       style: TextStyle(fontSize: 30,  fontWeight: FontWeight.bold,),
                   )
                   ],
                    ) 
                  ),
                TextButton(
                child: Text("REGISTER",
                style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
                style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.only(left: 80,right: 80,top: 30,bottom: 30)),
                        backgroundColor:MaterialStateProperty.all<Color>(Color.fromARGB(255, 67, 30, 233)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            ))),
                onPressed: () => null),
                ],
              )
            ) 
          ),
            ],
          ) 
        ),
      ),
    );
  }
}
