// ignore_for_file: camel_case_types

import 'package:flutter/cupertino.dart';

class countDown extends StatefulWidget{
  final int countX;
  const countDown({super.key , required this.countX});

  @override
  State<countDown> createState() {
    return _countDownState();
  }
}

class _countDownState extends State<countDown> {
  int count = 0;

  Future<void> counter (int countX) async {
    count = countX;
    for(int i = countX ; i >= 0 ; i--){
      await Future.delayed(const Duration(milliseconds: 1000) , () {
        count = i;
        if(mounted){
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    counter(widget.countX);
  }

  @override
  Widget build(BuildContext context) {
    return Text("$count" , style: const TextStyle(fontSize: 24));
  }
}