import 'dart:async';
import 'dart:core';
import 'dart:html';
import 'dart:math';

import 'package:appclient/models/productFvoriteModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appclient/models/productModel.dart';
import 'package:appclient/Screen/DetailFavariteProduct.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<ListFavorite> products = []; // Danh sách sản phẩm từ API


  Future<void> fetchFavoritesProducts() async {
    final response = await http.get(Uri.parse(
        'http://$BASE_API:6868/api/getListFavorite/6549d3feffe41106e077bd42')); // Thay thế URL của API sản phẩm
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('listFavorite') &&
            responseData['listFavorite'] is Map) {
          final Map<String, dynamic> favoriteData =
              responseData['listFavorite'] as Map<String, dynamic>;

          setState(() {
            products = [ListFavorite.fromJson(favoriteData)];
          });
        } else {
          print('Invalid data format: listFavorite is not a Map');
        }
      } catch (e) {
        print('Error parsing JSON: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

void _removeItemFromFavorite(String favoriteId) async {
  try {
    final response = await http.get(
      Uri.parse('http://$BASE_API:6868/api/deleteFavorite/$favoriteId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Xử lý khi xóa thành công
      print('Removed from cart successfully!');
      // Gọi lại hàm fetchProducts để làm mới danh sách
      fetchFavoritesProducts();
    } else {
      // Xử lý khi xóa không thành công
      print(
          'Failed to remove from cart. Status code: ${response.statusCode}');
    }
  } catch (error) {
    // Xử lý khi có lỗi
    print('Error removing from cart: $error');
  }
}

  @override
  void initState() {
     
    super.initState();
    fetchFavoritesProducts();
    
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
          'Favorite',
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
                    print(product.productId?.name);
                    return GestureDetector(
                      onTap: () {
                        // Xử lý khi bạn click vào item
                        print('Bạn đã click vào sản phẩm: ${product.sId}');
                        // Navigator.pushNamed(context, '/detaiproduct');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailFavoriteProduct(
                              title: 'Chi tiết sản phẩm',
                              productfvr: product,
                              // Truyền đối tượng sản phẩm đã được chọn
                            ),
                          ),
                        );
                      },
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
                                      base64Decode(product.productId?.image
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
                                        Expanded(
                                          flex: 7,
                                          child: Text(
                                            product.productId?.name ??
                                                "Unknown",
                                            style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff6342E8)),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '\$${product.productId?.price ?? 'Unknown Price'}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff6342E8),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    "Add to cart",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  )),
                                            ],
                                          ),
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

                                  if (product.sId != null) {
                                    _removeItemFromFavorite(product.sId!);
                                  } else {}
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
                    'ADD ALL TO CART',
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
