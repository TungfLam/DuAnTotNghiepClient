// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:appclient/Widgets/itemComment.dart';
import 'package:appclient/Widgets/loading.dart';
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
  List<String> arrIdComment = [];
  String idUser = '';
  String idBill = '';
  bool isNewComment = true;
  bool _isLoading = false;

  Future<void> getProductBill() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      idUser = prefs.getString("idUser")!;
    }catch(e){
      print(e);
      Navigator.pop(context);
    }

    final response = await http.get(
      Uri.parse("$BASE_API/api/bill-by-id/$idBill")
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
          arrIdComment = List.generate(productBill.length, (index) => "");

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
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> postComment(String IdProductDetail, String IdProduct, String comment, String rating, List<XFile> images) async {
    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest('POST' , Uri.parse("$BASE_API/api/comment"));

    for(var image in images){
      final File file = File(image.path);
      request.files.add(
          await http.MultipartFile.fromPath('images',file.path , filename: image.name)
      );
    }

    request.fields['ProductDetailId'] = IdProductDetail;
    request.fields['ProductId'] = IdProduct;
    request.fields['UserId'] = idUser;
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
    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> getComment(String idProductDetail , int index) async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
      Uri.parse("$BASE_API/api/comment-by-id"),
      headers: <String , String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String , String>{
        'ProductDetailId' : idProductDetail,
        'UserId' : idUser
      })
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);

      if(!data['err']!){
        isNewComment = false;
        arrIdComment[index] = data['objComment']['_id'];
        arrStar[index].text = data['objComment']['rating'].toString();

        List img = await data['objComment']['images'];
        if(img.isNotEmpty){
          for(var item in img){
            imagescall[index].add(item.toString());
          }
        }
        arrComment[index].text = data['objComment']['comment'] ?? "";
      }else{
        arrStar[index].text = '5';
      }

    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> updateComment(String idComment , List<XFile> images, String comment, String rating,) async {
    setState(() {
      _isLoading = true;
    });
    final request = http.MultipartRequest('PUT' , Uri.parse("$BASE_API/api/comment/$idComment"));

    for(var image in images){
      File file = File(image.path);
      request.files.add(
          await http.MultipartFile.fromPath('images', file.path , filename: image.name)
      );
    }

    request.fields['Comment'] = comment;
    request.fields['rating'] = rating;

    final response = await request.send();

    if(response.statusCode == 200){
      final data = jsonDecode(await response.stream.bytesToString());
      if(data['err']){
        showSnackBarErr(context, "Update : ${data['msg']}");
      }else{
        showSnackBar(context, "Update : ${data['msg']}");
      }
    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }

    setState(() {
      _isLoading = false;
    });

  }

  Future<void> _pickImages(int index) async {
    _images[index] = await ImagePicker().pickMultiImage(
      imageQuality: 80
    );
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    idBill = ModalRoute.of(context)!.settings.arguments.toString();
    if(idBill == ''){
      return;
    }
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
              isNewComment ? clickPostComment() : clickUpdateCommetn();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                isNewComment ? Icons.send : Icons.update,
                color: const Color(0xFF6C4EE7),
              ),
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: Stack(
        children: [
          Container(
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

          _isLoading ? const showLoading() : const SizedBox()
        ],
      ),
    );
  }

  void clickPostComment(){
    for(int i = 0; i < productBill.length ; i++){
      if(arrComment[i].text.length > 200){
        showSnackBarErr(context, "Đánh giá không quá 200 kí tự");
        return;
      }
      postComment(productBill[i]['product_id'] , productBill[i]['product_data']['product_id'], arrComment[i].text, arrStar[i].text, _images[i]);
    }
  }

  void clickUpdateCommetn(){
    for(int i = 0; i < productBill.length ; i++){
      if(arrComment[i].text.length > 200){
        showSnackBarErr(context, "Đánh giá không quá 200 kí tự");
        return;
      }
      updateComment(arrIdComment[i], _images[i],  arrComment[i].text, arrStar[i].text);

    }
  }
}