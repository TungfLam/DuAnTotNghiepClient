import 'package:flutter/material.dart';

void showSnackBar(BuildContext context , String content){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: const TextStyle(color: Colors.white) ),
      backgroundColor: Colors.green,
    ),
  );
}

void showSnackBarErr(BuildContext context , String content){
   ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content: Text(content, style: const TextStyle(color: Colors.white) ),
      backgroundColor: Colors.red,
    ),
  );
}
