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

class Find extends StatefulWidget {
  const Find({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
  List<productModel> products = []; // Danh sách sản phẩm từ API
  bool isLoadingMore = false;
  int page = 1;
  String _selectedSortOption = 'Sort Down';
  String searchText = ''; // Biến để lưu trữ dữ liệu từ TextField

  // Hàm để gọi API và cập nhật danh sách sản phẩm
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.118:6868/api/products/search?searchValues=$searchText')); // Thay thế URL của API sản phẩm
    print(searchText);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('listProducts') &&
            responseData['listProducts'] is List) {
          final List<dynamic> productListData =
              responseData['listProducts'] as List<dynamic>;

          setState(() {
            products = productListData
                .map((item) => productModel.fromJson(item))
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
          'Find Products',
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
              controller: TextEditingController(text: searchText),
              onChanged: (value) {
                searchText=value;
              },
              onSubmitted: (value) {
                // Kiểm tra xem giá trị đã nhập có khác rỗng không trước khi gọi API
                if (value.trim().isNotEmpty) {
                  fetchProducts();
                }
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                filled: true, // Đặt filled thành true để có màu nền
                fillColor: const Color(0xFFF2F3F2), // Đặt màu nền
                border: OutlineInputBorder(
                  borderSide: BorderSide.none, // Xóa đường viền
                  borderRadius:
                      BorderRadius.circular(20.0), // Điều chỉnh radius tại đây
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
                          child: Text('Filter & Sort',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              products.sort((a, b) =>
                                  (a.price ?? 0).compareTo(b.price ?? 0));
                            } else if (value == 'Sort Up') {
                              // Sắp xếp danh sách sản phẩm theo thứ tự tăng dần
                              // Đặt logic sắp xếp ở đây
                              products.sort((a, b) =>
                                  (b.price ?? 0).compareTo(a.price ?? 0));
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Sort Down',
                              child: Text('Sort Down'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Sort Up',
                              child: Text('Sort Up'),
                            ),
                          ],
                          child: Icon(
                              Icons.filter_list), // Biểu tượng sắp xếp xuống
                        ),
                      ],
                    ),
                    Expanded(
                      //phải có gridview như này này

                        child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemCount:
                          isLoadingMore ? products.length + 1 : products.length,
                      itemBuilder: (context, index) {
                        if (index < products.length) {
                          final product = products[index];

                          return GestureDetector(
                            onTap: () {
                              // Xử lý khi bạn click vào item
                              print(
                                  'Bạn đã click vào sản phẩm: ${product.sId}');
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
                            //cái card này viết trong listview
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
                                                padding:
                                                    EdgeInsets.only(top: 10),
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
                                                  icon: Icon(Icons
                                                      .favorite_border_outlined),
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
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 10, 5),
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
                                            padding:
                                                EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              '\$${product.price ?? 'Unknown Price'}',
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
                    )
                    )
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
