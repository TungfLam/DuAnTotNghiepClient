
import 'package:flutter/material.dart';

class Signup extends StatefulWidget{
    const Signup({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Signup> createState() => _SignupState();
}
class _SignupState extends State<Signup>{
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
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
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
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
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
            child: Text("Sign Up",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue) ,
            onPressed: (){},
          ),
        ),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
   
    Icon(Icons.facebook_sharp, size: 50.0, color: Colors.pink),
   
  
    Icon(Icons.facebook_sharp, size: 50.0, color: Colors.cyan,),
  ],
),

        
       Container(
        
            height: 130,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("ALREADY A ACCOUNT? SIGN IN", 
                style: TextStyle(fontSize: 15, color:Colors.blue),
                ),
                ],
              ),
          ),
        ],
        ),
      ),
     );
   }
   
}