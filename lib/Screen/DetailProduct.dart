import 'dart:convert';
import 'package:appclient/models/productSizeColor.dart';
import 'package:http/http.dart' as http;
import 'package:appclient/models/productModel.dart';
import 'package:flutter/material.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({Key? key, required this.title, this.product})
      : super(key: key);
  final String title;
  final productModel? product;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  String _selectedSize = ''; // Biến lưu kích thước đã chọn
  List<ProductListSize> productList = [];
  List<String> sizeList = [];
  int maxQuantity = 10;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  Future<void> fetchProductList() async {
    final response = await http.get(Uri.parse(
        'http://192.168.45.105:3000/api/getListAll_deltail/${widget.product?.sId}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['productListSize'];

      if (mounted) {
        setState(() {
          productList =
              data.map((item) => ProductListSize.fromJson(item)).toList();
        });
      }

      print('Fetched product list: $productList');
      productList.forEach((productListSize) {
        print('Quantity: ${productListSize.quantity}');
        sizeList.add('${productListSize.sizeId?.name}');
      });
    }
  }

  Widget _buildSizeOption(String size) {
    bool isSelected = _selectedSize == size;
    String selectedSizeQuantity = "";

    if (isSelected) {
      setState(() {
        final selectedProductSize = productList.firstWhere(
            (productListSize) => productListSize.sizeId?.name == size);

        selectedSizeQuantity = selectedProductSize.quantity.toString();
      });
    }
    if (isSelected) {
      print('Selected size: $_selectedSize');
      print('Quantity: $selectedSizeQuantity');
      setState(() {
        maxQuantity = int.parse('$selectedSizeQuantity');
      });
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSize = '';
            // Bỏ chọn kích thước nếu đã chọn rồi
          } else {
            _selectedSize = size;
            // Chọn kích thước nếu chưa chọn
          }
          print('Selected size: $_selectedSize'); // In ra kích thước đã chọn
        });
      },
      child: Container(
        width: 47,
        height: 47,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6342E8) : Color(0xFFF1F4FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Initialize the quantity with 1

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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  color: Color.fromARGB(255, 198, 198, 198),
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.memory(
                      base64Decode(widget.product?.image?.elementAt(0) ?? ''),
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                  widget.product?.name ??
                                      'Unknown Product Name',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '\$${widget.product?.price ?? 0.00}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              width: 120,
                              height: 40,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      decreaseQuantity(); // Call the decreaseQuantity function
                                    },
                                  ),
                                  Text(
                                    quantity
                                        .toString(), // Display the updated quantity
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      increaseQuantity(); // Call the increaseQuantity function
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          //descripsion
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Descripsion: ",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.product?.description ??
                                    'Unknown Product Name',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Container(
                          //size
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "select size",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: sizeList.map((size) {
                                  return _buildSizeOption(size);
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 50),
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
                                'ADD TO CART',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF6342E8), // Đặt màu nền
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Xử lý khi nhấn nút back
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  // Xử lý khi nhấn nút favorite
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
