import 'dart:convert';

import 'package:appclient/Widgets/itemComment.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllComment extends StatefulWidget{
  static const nameComment = "/allComment";

  const AllComment({super.key});

  @override
  State<AllComment> createState() => _AllCommentState();
}

const List<String> list = <String>[ '0','1', '2', '3', '4', '5'];
class _AllCommentState extends State<AllComment> {
  String dropdownValue = list.first;
  String idProduct = '';
  List arrComment = [];

  Future<void> getComment() async {
    final response = await http.get(
        Uri.parse("$BASE_API/api/comment/$idProduct?star=$dropdownValue")
    );

    if(response.statusCode == 200){
      final data = await json.decode(response.body);
      arrComment = data;
      print(arrComment.length);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    idProduct = ModalRoute.of(context)!.settings.arguments.toString();
    if(idProduct == ""){
      return;
    }
    getComment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Bình luận"),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric( horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                DropdownButton(
                  value: dropdownValue,
                  icon: const Icon(Icons.star , color: Colors.yellow,),
                  elevation: 4,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      getComment();
                      setState(() {});
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      alignment: Alignment.center,
                      child: (value == '0') ? const Text(" Tất cả ") : Text(" $value Sao "),
                    );
                  }).toList()
                )
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: arrComment.map((e) => itemComment(item: e)).toList(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}