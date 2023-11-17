import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appclient/models/productCartModel.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<ListCart> products = [];
  int maxQuantity = 10;
  int quantity = 1;
  final ip = '192.168.45.105';

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://$ip:6868/api/getListCart/6549d3feffe41106e077bd42'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        // In ra dữ liệu JSON để kiểm tra cấu trúc
        print('JSON Data: $responseData');

        if (responseData.containsKey('listCart')) {
          final dynamic listCartData = responseData['listCart'];

          if (listCartData is List) {
            setState(() {
              products =
                  listCartData.map((item) => ListCart.fromJson(item)).toList();
              print(products.length);
            });
          } else {
            print('Invalid data format for listCart');
          }
        } else {
          print('Key listCart not found in JSON response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

  void _removeItemFromCart(String cartId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://$ip:6868/api/deleteCart/$cartId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Xử lý khi xóa thành công
        print('Removed from cart successfully!');
        // Gọi lại hàm fetchProducts để cập nhật danh sách sản phẩm sau khi xóa
        fetchProducts();
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 2.5,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    if (product.productId != null) {
                      print(product.productId?.quantity);
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
                                            '..'),
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
                                                '\$${product.productId?.product?.price ?? ''}',
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    width: 115,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.grey),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
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
                                                            Icons.remove,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            decreaseQuantity();
                                                          },
                                                        ),
                                                        Text(
                                                          quantity.toString(),
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.add,
                                                            size: 20,
                                                          ),
                                                          onPressed: () {
                                                            increaseQuantity();
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
                                    if (product.sId != null) {
                                      _removeItemFromCart(product.sId!);
                                    } else {
                                      print(
                                          'CartId is null for product at index $index');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      print('productId is null for product at index $index');
                      return const SizedBox
                          .shrink(); // Nếu productId là null, có thể trả về một widget trống hoặc thích hợp khác.
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle button pressed
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'GO TO CHECKOUT',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6342E8),
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
