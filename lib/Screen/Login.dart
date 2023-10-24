
import 'package:flutter/material.dart';

class Login extends StatefulWidget{
    const Login({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Login> createState() => _LoginState();
}
class _LoginState extends State<Login>{
   Widget build(BuildContext context){
     return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Xử lý khi người dùng nhấn nút back
          },
        ),
        title: const Text(
          'Find Products',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB( 30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Container(
              width: 70,
              height: 70,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xffd8d8d8)),
              child: FlutterLogo()),
          ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text("Hello\nWelcome Back", style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black,
                fontSize: 30),
                
              ),
            ),
            Padding(
             padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                labelText: "UserName", labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)),
                
                ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                    labelText: "PassWord", labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)),
                    
                    ),
                 
                Text("Show", style: TextStyle(color: Colors.blue, fontSize: 13,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
        Center(
          child: ElevatedButton(
            child: Text("Sign In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue) ,
            onPressed: (){},
          ),
        ),
       Container(
            height: 130,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("NEW USER? SIGN UP", 
                style: TextStyle(fontSize: 15, color: Color(0xffd8d8d8d)),
                ),
                Text("FORGOT PASSWORD?", style: TextStyle(fontSize: 15, color: Colors.blue),)
                ],
              ),
          ),
        ],
        ),
      ),
     );
   }
   
}