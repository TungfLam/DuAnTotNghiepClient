// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:appclient/Widgets/itemComment.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddComment extends StatefulWidget{
  static const nameAddComment = "/addComment";

  const AddComment({super.key});

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  List productBill = [];
  List<List<XFile>> _images = [];
  List<TextEditingController> arrStar = [];
  List<TextEditingController> arrComment = [];
  String idUser = '';

  Future<void> getProductBill() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getString("idUser")!;
    final response = await http.get(
      Uri.parse("$BASE_API/api/bill-by-id/6581d7275e380e8480224ff9")
    );

    if(response.statusCode == 200){
      final data = await jsonDecode(response.body);
      if(!data['err']){
        if(data['objBill']['status'] == 7){
          productBill = data['objBill']['cart_data'];
          _images = List.generate(productBill.length, (index) => []);
          arrStar = List.generate(productBill.length, (index) => TextEditingController());
          arrComment = List.generate(productBill.length, (index) => TextEditingController());
          setState(() {});
        }else{
          showSnackBarErr(context, "Hoàn thành đơn hàng để đánh giá");
          Navigator.pop(context);
        }
      }else{
        showSnackBarErr(context, "Không tìm thấy bill");
        Navigator.pop(context);
      }
    }else{
      showSnackBarErr(context, "Err : lỗi server");
      Navigator.pop(context);
    }
  }

  Future<void> postComment(String IdProduct, String IdUser, String comment, String rating, List<XFile> images) async {

    final request = http.MultipartRequest('POST' , Uri.parse("$BASE_API/api/comment"));

    images.map((e) {
      final File file = File(e.path);
      request.files.add(
          http.MultipartFile.fromBytes('images', file.readAsBytesSync() , filename: e.name)
      );
    });

    request.fields['ProductId'] = IdProduct;
    request.fields['UserId'] = "6524318746e12608b3558d74";
    request.fields['Comment'] = comment;
    request.fields['rating'] = rating;

    final response = await request.send();

    if(response.statusCode == 200){
      final res = ApiRes.fromJson(jsonDecode(await response.stream.bytesToString()));
      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }else{
        showSnackBar(context, res.msg!);
      }
      print("thanh cong");
    }else{
      print("that bai");
    }
  }

  Future<void> _pickImages(int index) async {
    _images[index] = await ImagePicker().pickMultiImage(
      imageQuality: 80
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getProductBill();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đánh giá sản phẩm"),
        actions: [
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: (){
              for(int i = 0; i < productBill.length ; i++){
                print("${arrStar[i].text} -- ${arrComment[i].text}");
                  postComment(productBill[i]['product_id'], idUser, arrComment[i].text, arrStar[i].text, _images[i]);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.send,
                color: Color(0xFF6C4EE7),
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: productBill.map((e) {
              int index = productBill.indexOf(e);
              return itemAddComment(
                item: e,
                starCtrl: arrStar[index],
                commentCtrl: arrComment[index],
                pickImage: _pickImages,
                images: _images[index],
                index: index,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}