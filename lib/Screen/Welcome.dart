import 'package:flutter/material.dart';

class Welcome extends StatefulWidget{
    const Welcome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Welcome> createState() => _WelcomeState();
}
  class _WelcomeState extends State<Welcome>{
    Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                 Color(0xffF5F5F5),
                 Color(0xff7B68EE),
              ]
            ),
          ),
          child: Column(
            children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  
                  child: Image(image: AssetImage("lib/images/logo2.jpg"),
                  width: 200,
                  height: 200,
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                Text('WelCome Back Adadas', style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
                ),
                SizedBox(height:40,),
                Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('SIGN IN',style: TextStyle(
                    fontSize: 20,
                     fontWeight: FontWeight.bold,
                    color: Colors.white)
                    ),
                ),
                ),
                 SizedBox(height:25
                 ,),
                Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(child: Text('SIGN UP',style: TextStyle(
                    fontSize: 20,
                     fontWeight: FontWeight.bold,
                    color: Colors.black)
                    ),
                ),
                ),
                Spacer(),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,100, 0, 0),
                  child: Text('Login with Social Media',style: TextStyle(
                      fontSize: 17,
                      color: Colors.white),
                      ),
                ),
                    SizedBox(height:0 ,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image(image: AssetImage("lib/images/anh1.webp"),
                       width: 150,height: 150,
                      
                      ),
                    ),
          ],
          ),
        ),
      );
    }

  }