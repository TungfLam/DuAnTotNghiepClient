import 'package:appclient/models/productCartModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'dart:ffi';

import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyCart extends StatefulWidget {
  const MyCart({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<productCartModel> products = []; //

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'http://192.168.45.105:6868/api/getListCart/6549d3feffe41106e077bd42')); // Thay thế URL của API sản phẩm

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('listCart') &&
            responseData['listCart'] is List) {
          final List<dynamic> productListData =
              responseData['listCart'] as List<dynamic>;

          setState(() {
            products = productListData
                .map((item) => productCartModel.fromJson(item))
                .toList();
          });
        } else {
          print('Invalid data format');
        }
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi API khi widget được khởi tạo
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Xử lý khi người dùng nhấn nút back
          },
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: 620,
              child:           Expanded(
              //phải có gridview như này này
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: Card(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          height: 150,
                          margin: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 234, 240, 245),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Container(
                              height: 100,
                              width: 120,
                              margin: EdgeInsets.only(right: 15),
                              child: Image.asset("lib/images/aooo.png"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Printed Shirt",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4C53A5)),
                                  ),
                                  Text(
                                    "\$28.00 USD",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.delete,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              )
                                            ]),
                                        child: Icon(
                                          CupertinoIcons.plus,
                                          size: 18,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          "01",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4C53A5),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 10,
                                              )
                                            ]),
                                        child: Icon(
                                          CupertinoIcons.minus,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
            ),
          ),
          // cái lisview của tôi đâu
          //k có list view thì item biết bỏ vào đâu

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Xử lý khi nút được nhấn
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ), // Icon tùy chọn
                  label: const Text(
                    'GO TO CHECKOUT',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6342E8), // Đặt màu nền
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
