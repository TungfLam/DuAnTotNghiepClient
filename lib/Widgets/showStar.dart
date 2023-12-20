
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class showStar extends StatelessWidget{
  var countStar;
  showStar({required this.countStar});

  @override
  Widget build(BuildContext context) {

    List<bool> listStar = [];
    for(int i = 1; i < 6; i++){
      if(i <= countStar){
        listStar.add(true);
      }else{
        listStar.add(false);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: listStar.map((e) => Icon(
        e ? Icons.star : Icons.star_border_outlined,
        color: Colors.yellow,
        size: 16,
      ) ).toList()
    );
  }

}