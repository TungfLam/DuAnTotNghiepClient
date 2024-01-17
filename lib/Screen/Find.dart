import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';

import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/models/productModel.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class Find extends StatefulWidget {
  const Find({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
  TextEditingController searchController = TextEditingController();
  List<productModel> products = [];
  bool isLoadingMore = false;
  int page = 1;
  String _selectedSortOption = 'Sắp xếp giảm dần';
  String searchText = '';

  Future<void> fetchsearchProducts() async {
    final response = await http.get(Uri.parse(
        '$BASE_API/api/products?searchValues=$searchText'));

    print(searchText);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> productListData =
              responseData['data'] as List<dynamic>;

          setState(() {
            products = productListData
                .map((item) => productModel.fromJson(item))
                .toList();
          });
        } else {
          print('Dữ liệu từ API không chứa danh sách sản phẩm.');
        }
      } catch (e) {
        print('Lỗi khi giải mã JSON: $e');
      }
    } else {
      print('Lỗi khi gọi API: ${response.statusCode}');
    }
  }

  Future<void> fetchProducts() async {
    final response = await http.get(
      Uri.parse('$BASE_API/api/products/$page'),
      headers: {'Content-Type': 'application/json'},
    ); // Thay thế URL của API sản phẩm

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
    fetchProducts();
    searchController.addListener(() {
      setState(() {
        searchText = searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Tìm kiếm sản phẩm',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  fetchsearchProducts();
                }
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF2F3F2),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text('Bộ lọc & Sắp xếp',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String value) {
                            setState(() {
                              _selectedSortOption = value;
                            });

                            if (value == 'Sắp xếp giảm dần') {
                              products.sort((a, b) =>
                                  (a.price ?? 0).compareTo(b.price ?? 0));
                            } else if (value == 'Sắp xếp tăng dần') {
                              products.sort((a, b) =>
                                  (b.price ?? 0).compareTo(a.price ?? 0));
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Sắp xếp giảm dần',
                              child: Text('Sắp xếp giảm dần'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Sắp xếp tăng dần',
                              child: Text('Sắp xếp tăng dần'),
                            ),
                          ],
                          child: Icon(Icons.filter_list),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: isLoadingMore
                            ? products.length + 1
                            : products.length,
                        itemBuilder: (context, index) {
                          if (index < products.length) {
                            final product = products[index];

                            return GestureDetector(
                              onTap: () {
                                print(
                                    'Bạn đã click vào sản phẩm: ${product.sId}');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailProduct(
                                      title: 'Chi tiết sản phẩm',
                                      product: product,
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
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Image.network(
                                                        '${product.image?.elementAt(0)}' ??
                                                            'loading...',
                                                        height: 200,
                                                        width: 180,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object error,
                                                                StackTrace?
                                                                    stackTrace) {
                                                      return Center(
                                                          child: const Icon(
                                                              Icons.image));
                                                    }),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: IconButton(
                                                    icon: const Icon(Icons
                                                        .favorite_border_outlined),
                                                    onPressed: () {},
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 5),
                                              child: Text(
                                                product.name ?? 'Không rõ',
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
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Text(
                                                '${NumberFormat.decimalPattern().format(product.price ?? 'Giá không rõ')} đ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 105, 105, 105),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
