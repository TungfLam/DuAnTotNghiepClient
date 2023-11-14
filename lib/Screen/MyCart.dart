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
  List<ListCart> products = []; //
  int maxQuantity = 10;
  int quantity = 1;

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
            products =
                productListData.map((item) => ListCart.fromJson(item)).toList();
            print(products.length);
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

  void increaseQuantity() {
    if (quantity < maxQuantity) {
      setState(() {
        quantity++;
      });
    }
  }

  void decreaseQuantity() {
    if (quantity > 0) {
      // Make sure quantity doesn't go below 1
      setState(() {
        quantity--;
      });
    }
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
              //phải có gridview như này này
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 2.2,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    print(product.productId?.product?.image);
                    return GestureDetector(
                      child: Card(
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.memory(
                                      base64Decode(product
                                              .productId?.product?.image
                                              ?.elementAt(0) ??
                                          ''),
                                      height: 200,
                                      width: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 30, 10, 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          product.productId?.product?.name ??
                                              "Unknown",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff6342E8)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${product.productId?.product?.price ?? 'Unknown Price'}',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  width: 115,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.remove,size: 20,),
                                                        onPressed: () {
                                                          decreaseQuantity(); // Call the decreaseQuantity function
                                                        },
                                                      ),
                                                      Text(
                                                        quantity
                                                            .toString(), // Display the updated quantity
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.add,size: 20,),
                                                        onPressed: () {
                                                          increaseQuantity(); // Call the increaseQuantity function
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.black),
                                onPressed: () {
                                  // Xử lý khi nút "x" được nhấn
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    if (mounted) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                  return null;
                },
              ),
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
