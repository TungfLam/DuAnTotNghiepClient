// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/productModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class itemNotification extends StatefulWidget{

  var notification;

  itemNotification({super.key, required this.notification});

  @override
  State<itemNotification> createState() => _itemNotificationState();
}

class _itemNotificationState extends State<itemNotification> {
  DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
  bool isRead = true;
  late productModel objProduct;

  Future<void> setStatusR () async{
    final response = await http.get(
      Uri.parse("$BASE_API/api/notification-read/${widget.notification.sId}")
    );

    if(response.statusCode == 200){
      isRead = false;
      setState(() {});
    }
  }

  Future<void> _getProduct(String id) async {
    final response = await http.get(
      Uri.parse("$BASE_API/api/product-by-id/657844c0da370f7828dd7bc0"),
    );

    if(response.statusCode == 200){
      final data = await jsonDecode(response.body);

      if(!data['err']){
        objProduct = productModel.fromJson(data['objProduct']);
      }else{
        print("err api");
      }

    }else{
      print("err sv");
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    isRead = widget.notification.status;
  }

  @override
  Widget build(BuildContext context) {

    DateTime time = DateTime.parse(widget.notification.date);
    String date = "${time.hour + 7}:${time.minute} ${time.day}-${time.month}-${time.year}";

    return InkWell(
      onTap: () async {
        switch(widget.notification.statuPayload){
          case '0':
            setStatusR();
            break;
          case '1':
            setStatusR();
            await _getProduct(widget.notification.payload);

            print(objProduct.name);

            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                DetailProduct(
                  title: "title",
                  product: objProduct,
                )
            ));
            break;
          case '2':
            setStatusR();
            break;
        }

      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top : 4,bottom: 12, left: 16 , right: 16),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isRead ? const Color(0xFFE5EBF6) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.notification.title}" ,style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 4),
            (widget.notification.image.toString().isEmpty) ?
            Text("${widget.notification.content}",style: const TextStyle(
              fontSize: 18
            ),) :
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                        child: Image.network(
                            "$BASE_API${widget.notification.image}",
                            height: 64,
                            width: 64,
                            errorBuilder: (BuildContext context , Object error, StackTrace? stackTrace){
                              return const Icon(Icons.image ,size: 72,);
                            }
                        )
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 8,
                        child: Text("${widget.notification.content}",style: const TextStyle(
                            fontSize: 18
                        ))
                    )
                  ],
                ),
           Container(
             width: double.infinity,
             alignment: Alignment.centerRight,
             child: Text(date),
           )
          ],
        ),
      ),
    );
  }
}