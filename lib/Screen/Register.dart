import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xff7B68EE),
              Color(0xffF5F5F5),
            ]),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Create Your\nAccount',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Your Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          )),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.check,
                            color: Colors.grey,
                          ),
                          label: Text(
                            'Gmail or Phone',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.red),
                          )),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'PassWord',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Confirm PassWord',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                        SizedBox(height: 70,),
                    Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(colors: [
                          Color(0xff7B68EE),
                          Color(0xffF5F5F5),
                        ]),
                      ),
                      child: Center(child: Text('SIGN UP', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),),),
                    ),
                     SizedBox(height: 80,),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Don't have account?", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),),
                          Text("Sign In",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 17,
                          ),),

                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ],
    ));
  }
}
