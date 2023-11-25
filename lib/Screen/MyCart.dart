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
  String selectedPaymentMethod = '';
  List<String> paymentMethods = [
    'Thanh toán khi nhận hàng',
    'Thanh toán VNPAY'
  ];

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://adadas.onrender.com/api/getListCart/6524318746e12608b3558d74'),
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
        Uri.parse('https://adadas.onrender.com/api/deleteCart/$cartId'),
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

  void _showProductDetailsModal(BuildContext context, ListCart product) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          // Nội dung của modal bottom sheet
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Hiển thị thông tin chi tiết về sản phẩm (ví dụ: tên, giá, màu sắc, kích thước, v.v.)
              // Các thông tin có thể được truy cập thông qua đối tượng `product` được truyền vào hàm này.
              Center(
                child: Text(
                  product.productId?.product?.name ?? "Unknown",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff6342E8)),
                ),
              ),

              // Chọn phương thức thanh toán
              Container(
                width: double.infinity,
                child: DropdownButton<String>(
                  value: selectedPaymentMethod.isNotEmpty
                      ? selectedPaymentMethod
                      : null,
                  hint: Text(
                    'Phương thức thanh toán: ${selectedPaymentMethod}',
                    style: TextStyle(
                      color: selectedPaymentMethod.isNotEmpty
                          ? Colors.black
                          : Colors.grey,
                    ),
                  ),
                  onChanged: (String? newPaymentMethod) {
                    setState(() {
                      selectedPaymentMethod = newPaymentMethod!;
                      
                    });
                  },
                  items: paymentMethods.map((String paymentMethod) {
                    return DropdownMenuItem<String>(
                      value: paymentMethod,
                      child: Text(paymentMethod),
                    );
                  }).toList(),
                ),
              ),

              Container(child: const Text("phiếu giảm giá")),

              Text("Tổng tiền: ${product.productId?.product?.price}"),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle button pressed
                    print('phương thức tt đã chọn: $selectedPaymentMethod');
                  },
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Đặt hàng',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6342E8),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    
  }

  void increaseQuantity(int quantity, int maxQuantity) {
    if (quantity < maxQuantity) {
      setState(() {
        quantity++;
      });
    }
  }

  void decreaseQuantity(int quantity, int maxQuantity) {
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
          'Giỏ hàng',
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
                  childAspectRatio: 2,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  if (index < products.length) {
                    final product = products[index];
                    if (product.productId != null) {
                      print(product.productId?.quantity);
                      return GestureDetector(
                        onTap: () {
                          if (index < products.length) {
                            final product = products[index];
                            if (product.productId != null) {
                              _showProductDetailsModal(context, product);
                              print(
                                  'soluongmax: ${product.productId!.quantity!}');
                            }
                          }
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
                                          0, 10, 30, 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              product.productId?.product
                                                      ?.name ??
                                                  "Unknown",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff6342E8)),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Kích cỡ: ${product.productId?.sizeId?.name ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Màu sắc: ${product.productId?.colorId?.name ?? ''}',
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '\đ${product.productId?.product?.price ?? ''}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                // Container(
                                                //   child: Text(
                                                //     'Số Lượng: ${product.quantity ?? ''}',
                                                //     style: const TextStyle(
                                                //         fontSize: 15,
                                                //         fontWeight:
                                                //             FontWeight.bold),
                                                //   ),
                                                // ),
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
