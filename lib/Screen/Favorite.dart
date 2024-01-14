import 'dart:async';
import 'dart:core';

import 'package:appclient/models/productFvoriteModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appclient/Screen/DetailFavariteProduct.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<ListFavorite> products = []; // Danh sách sản phẩm từ API

  Future<void> fetchFavoritesProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    if (isLogin != null) {
      if (isLogin == true) {
        print("người dùng đã login");
      } else if (isLogin == false) {
        Navigator.pushNamed(context, '/login');
      }
    }

    if (idUser != null) {
      print("user id là: $idUser");

      try {
        final response = await http.get(
          Uri.parse('$BASE_API/api/getListFavorite/$idUser'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData.containsKey('listFavorite') &&
              responseData['listFavorite'] is List) {
            final List<dynamic> favoriteData =
                responseData['listFavorite'] as List<dynamic>;

            setState(() {
              products = favoriteData
                  .map((favorite) => ListFavorite.fromJson(favorite))
                  .toList();
            });
          } else {
            print('Invalid data format: listFavorite is not a List');
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching favorites: $e');
      }
    }
  }

  void _removeItemFromFavorite(String favoriteId) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_API/api/deleteFavorite/$favoriteId'),
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
          'Yêu thích',
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
                    if (product.productId != null) {
                      // Kiểm tra xem id product và product có khác null không
                      print(product.productId?.name);
                      return GestureDetector(
                        onTap: () {
                          // Xử lý khi bạn click vào item
                          print('Bạn đã click vào sản phẩm: ${product.sId}');
                          // Navigator.pushNamed(context, '/detaiproduct');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailFavariteProduct(
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
                                      child: Image.network(
                                          product.productId?.image
                                                  ?.elementAt(0) ??
                                              '',
                                          height: 200,
                                          width: 180,
                                          fit: BoxFit.cover, errorBuilder:
                                              (BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace) {
                                        return Center(
                                            child: const Icon(Icons.image));
                                      }),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 10, 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 40),
                                              child: Text(
                                                product.productId?.name ??
                                                    "Unknown",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff6342E8)),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${NumberFormat.decimalPattern().format(product.productId?.price ?? 'Unknown Price')} đ',
                                                  
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff6342E8),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(
                                                    Icons.shopify_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Xác nhận xóa sản phẩm'),
                                          content: const Text(
                                              'Bạn muốn xóa sản phẩm này?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Đóng hộp thoại
                                                if (product.sId != null) {
                                                  _removeItemFromFavorite(
                                                      product.sId!);
                                                } else {
                                                  print(
                                                      'CartId is null for product at index $index');
                                                }
                                              },
                                              child: const Text('Có'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Đóng hộp thoại
                                              },
                                              child: const Text('Hủy'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      print(
                          'ProductId or product is null for product at index $index');
                      return const SizedBox.shrink();
                    }
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
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.all(16.0),
          //     child: SizedBox(
          //       width: double.infinity,
          //       height: 50,
          //       child: ElevatedButton.icon(
          //         onPressed: () {
          //           // Xử lý khi nút được nhấn
          //         },
          //         icon: const Icon(
          //           Icons.shopping_cart,
          //           color: Colors.white,
          //         ), // Icon tùy chọn
          //         label: const Text(
          //           'ADD ALL TO CART',
          //           style: TextStyle(
          //               color: Colors.white, fontWeight: FontWeight.bold),
          //         ),
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: const Color(0xFF6342E8), // Đặt màu nền
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
