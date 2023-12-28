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
  List<List<String>> imagescall = [];
  List<List<XFile>> _images = [];
  List<TextEditingController> arrStar = [];
  List<TextEditingController> arrComment = [];
  String idUser = '';

  Future<void> getProductBill() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      idUser = prefs.getString("idUser")!;
    }catch(e){
      print(e);
      // Navigator.pop(context);
    }

    final response = await http.get(
      Uri.parse("$BASE_API/api/bill-by-id/65819a903c68d1ff1e421857")
    );

    if(response.statusCode == 200){
      final data = await jsonDecode(response.body);
      if(!data['err']){
        if(data['objBill']['status'] == 7){
          productBill = await data['objBill']['cart_data'];

          _images = List.generate(productBill.length, (index) => []);
          imagescall = List.generate(productBill.length, (index) => []);
          arrStar = List.generate(productBill.length, (index) => TextEditingController());
          arrComment = List.generate(productBill.length, (index) => TextEditingController());

          for(var item in productBill){
            int index = productBill.indexOf(item);
            await getComment(item['product_id'], index);
          }
          setState(() {
            print("reload...");
          });
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
      // Navigator.pop(context);
    }
  }

  Future<void> postComment(String IdProductDetail, String comment, String rating, List<XFile> images) async {

    final request = http.MultipartRequest('POST' , Uri.parse("$BASE_API/api/comment"));

    for(var image in images){
      final File file = File(image.path);
      request.files.add(
          await http.MultipartFile.fromPath('images',file.path , filename: image.name)
      );
    }

    request.fields['ProductId'] = IdProductDetail;
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

  Future<void> getComment(String idProductDetail , int index) async {
    final response = await http.post(
      Uri.parse("$BASE_API/api/comment-by-id"),
      headers: <String , String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String , String>{
        'ProductDetailId' : idProductDetail,
        'UserId' : "6524318746e12608b3558d74"
      })
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      if(!data['err']!){
        arrStar[index].text = data['objComment']['rating'].toString();

        List img = await data['objComment']['images'];
        if(img.length != 0){
          for(var item in img){
            print(item);
            imagescall[index].add(item.toString());
          }
        }
        print(arrStar[index].text);
        arrComment[index].text = data['objComment']['comment'] ?? "";
      }else{
        arrStar[index].text = '5';
      }

    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
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
                  postComment(productBill[i]['product_id'], arrComment[i].text, arrStar[i].text, _images[i]);
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.update,
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
                imagescall: imagescall[index],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}