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

Future<void> showDialogUilt(BuildContext context , String title , String content , Function onPressed) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  onPressed();
                },
                child: const Text("OK")
            )
          ],
        );
      }
  );
}

Future<void> showDialogUilt2(BuildContext context , String title , String content , Function onPressed) async {
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: const Text("back")
            ),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  onPressed();
                },
                child: const Text("OK")
            )
          ],
        );
      }
  );
}
