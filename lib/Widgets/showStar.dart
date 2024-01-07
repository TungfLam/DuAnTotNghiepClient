// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class showStar extends StatelessWidget{
  final int countStar;
  const showStar({super.key, required this.countStar});

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

class changeStar extends StatefulWidget{
  final TextEditingController starCtrl;
  const changeStar({super.key, required this.starCtrl});

  @override
  State<changeStar> createState() => _changeStarState();
}

class _changeStarState extends State<changeStar> {
  List<bool> arrValue = [];
  int indexStar = 5;
  String textValue = "Rất tốt";

  void updateArr(){
    int? chekn = int.tryParse(widget.starCtrl.text);
    if(chekn != null){
      indexStar = int.parse(widget.starCtrl.text);
    }

    arrValue.clear();
    for(int i = 1; i < 6; i++){
      if(i <= indexStar){
        arrValue.add(true);
      }else{
        arrValue.add(false);
      }
    }

    switch(indexStar){
      case 1:
        textValue = "Rất tệ";
        break;
      case 2:
        textValue = "Tệ";
        break;
      case 3:
        textValue = "Bình thường";
        break;
      case 4:
        textValue = "Tốt";
        break;
      case 5:
        textValue = "Rất tốt";
        break;
      default:
        textValue = "Lỗi rồi Duy ơi";
        break;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateArr();
    widget.starCtrl.addListener(() {
      updateArr();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(arrValue.length, (index) {
            return InkWell(
              onTap: (){
                indexStar = index + 1;
                widget.starCtrl.text = "$indexStar";
                updateArr();
              },
              child: Icon(
                arrValue[index] ? Icons.star : Icons.star_outline,
                color: Colors.yellow,
                size: 40,
              )
            );
          })
        ),
        
        Text(
          textValue,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8)
      ]
    );
  }
}
