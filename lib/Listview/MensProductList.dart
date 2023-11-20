import 'dart:async';
import 'dart:core';

import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/models/productModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MensProductList extends StatefulWidget {
  const MensProductList({super.key});

  @override
  _MensProductListState createState() => _MensProductListState();
}

class _MensProductListState extends State<MensProductList> {
  List<productModel> products = []; // Danh sách sản phẩm từ API
  final scrollController = ScrollController();
  bool isLoadingMore = false;
  int page = 1;
  String _selectedSortOption = 'Sort Down';

  // Hàm để gọi API và cập nhật danh sách sản phẩm
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'http://$BASE_API:6868/api/products/Men/$page')); // Thay thế URL của API sản phẩm
    if (response.statusCode == 200) {
      final List<dynamic>? productData = jsonDecode(response.body);
      if (productData != null && mounted) {
        setState(() {
          products = products +
              productData.map((item) => productModel.fromJson(item)).toList();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi API khi widget được khởi tạo
    scrollController.addListener(_scrollListener);
    fetchProducts();
  }

   @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text('Filter & Sort', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  _selectedSortOption = value;
                });
                // Thực hiện sắp xếp danh sách sản phẩm dựa trên giá trị được chọn (value)
                if (value == 'Sort Down') {
                  // Sắp xếp danh sách sản phẩm theo thứ tự giảm dần
                  // Đặt logic sắp xếp ở đây
                  products.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
                } else if (value == 'Sort Up') {
                  // Sắp xếp danh sách sản phẩm theo thứ tự tăng dần
                  // Đặt logic sắp xếp ở đây
                  products.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Sort Down',
                  child: Text('Sort Down'),
                ),
                const PopupMenuItem<String>(
                  value: 'Sort Up',
                  child: Text('Sort Up'),
                ),
              ],
              child: Icon(Icons.filter_list), // Biểu tượng sắp xếp xuống
            ),
          ],
        ),
        Expanded(
            child: GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: isLoadingMore ? products.length + 1 : products.length,
          itemBuilder: (context, index) {
            if (index < products.length) {
              final product = products[index];

              return GestureDetector(
                onTap: () {
                  // Xử lý khi bạn click vào item
                  print('Bạn đã click vào sản phẩm: ${product.sId}');
                  // Navigator.pushNamed(context, '/detaiproduct');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProduct(
                        title: 'Chi tiết sản phẩm',
                        product:
                            product, // Truyền đối tượng sản phẩm đã được chọn
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Image.memory(
                                      base64Decode(product.image
                                              ?.elementAt(0) ??
                                          'loading...'), // Giả sử danh sách ảnh là danh sách base64
                                      height: 200,
                                      width: 180,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.favorite_border_outlined),
                                      onPressed: () {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                                child: Text(
                                  product.name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  '\$${product.price ?? 'Unknown Price'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 105, 105, 105),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              if (mounted) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          },
        ))
      ],
    );
  }

  Future<void> _scrollListener() async{
    if (isLoadingMore) {
      return;
    }
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await fetchProducts();
      setState(() {
        isLoadingMore = false;
      });
    }

    // fetchProducts();
  }
}
