import 'dart:convert';
import 'package:appclient/models/productFvoriteModel.dart';
import 'package:appclient/models/productSizeColor.dart';
import 'package:http/http.dart' as http;
import 'package:appclient/models/productModel.dart';
import 'package:flutter/material.dart';

class DetailFavoriteProduct extends StatefulWidget {
  const DetailFavoriteProduct({Key? key, required this.title, this.productfvr})
      : super(key: key);
  final String title;
  final ListFavorite? productfvr;

  @override
  State<DetailFavoriteProduct> createState() => _DetailFavoriteProductState();
}

class _DetailFavoriteProductState extends State<DetailFavoriteProduct> {
  String _selectedSize = '';
  String _selectedColor = ''; // Biến lưu kích thước đã chọn
  List<ProductListSize> productList = [];
  List<String> sizeList = [];
  List<String> colorList = [];
  int maxQuantity = 0;
  int quantity = 0;
  int _selectedImageIndex = 0;
  ProductListSize? _selectedProductListSize;
  final ip = '192.168.45.105';

  @override
  void initState() {
    super.initState();
    fetchProductList();
  }

  Future<void> fetchProductList() async {
    try {
      final response = await http.read(
        Uri.parse(
          'https://adadas.onrender.com/api/getListAll_deltail/${widget.productfvr?.productId?.sId}',
        ),
        headers: {'Content-Type': 'application/json'},
      );
      print(widget.productfvr?.productId?.sId);
      // Xử lý dữ liệu response ở đây
      final List<dynamic> data = json.decode(response)['productListSize'];

      if (mounted) {
        setState(() {
          productList =
              data.map((item) => ProductListSize.fromJson(item)).toList();
        });
      }

      productList.forEach((productListSize) {
        print('Quantity: ${productListSize.quantity}');
        print('Quantity: ${productListSize.sizeId?.name}');
        print('idsizecolor : ${productListSize.sId}');
        sizeList.add('${productListSize.sizeId?.name}');
        colorList.add('${productListSize.colorId?.name}');
      });
    } catch (error) {
      print('Error fetching product list: $error');
    }
  }

  void addToCart(String productId, int quantity) async {
    try {
      if (_selectedProductListSize != null) {
        final response = await http.post(
          Uri.parse(
              'https://adadas.onrender.com/api/addCart/6524318746e12608b3558d74/$productId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'quantity': quantity}),
        );

        if (response.statusCode == 200) {
          // Xử lý khi thành công
          print('Added to cart successfully!');
        } else {
          // Xử lý khi không thành công
          print('Failed to add to cart. Status code: ${response.statusCode}');
        }
      } else {
        print('No size and color selected');
      }
    } catch (error) {
      // Xử lý khi có lỗi
      print('Error adding to cart: $error');
    }
  }

  void updateMaxQuantity() {
    if (_selectedSize.isNotEmpty && _selectedColor.isNotEmpty) {
      _selectedProductListSize = productList.firstWhere(
        (productListSize) =>
            productListSize.sizeId?.name == _selectedSize &&
            productListSize.colorId?.name == _selectedColor,
      );
      maxQuantity = _selectedProductListSize?.quantity ?? 0;
    } else {
      maxQuantity = 0;
    }
  }

  void updateSizeList() {
    sizeList.clear();
    colorList.clear();

    productList.forEach((productListSize) {
      sizeList.add('${productListSize.sizeId?.name}');
    });

    // Cập nhật danh sách màu dựa trên kích thước đã chọn
    if (_selectedSize.isNotEmpty) {
      productList
          .where((productListSize) =>
              productListSize.sizeId?.name == _selectedSize)
          .forEach((selectedProductSize) {
        if (selectedProductSize.colorId != null) {
          colorList.add('${selectedProductSize.colorId?.name}');
        }
      });
    }

    updateMaxQuantity();
  }

  List<String> getUniqueSizes() {
    Set<String> uniqueSizes = Set();
    List<String> result = [];

    productList.forEach((productListSize) {
      uniqueSizes.add(productListSize.sizeId?.name ?? '');
    });

    result.addAll(uniqueSizes);
    return result;
  }

  Widget _buildSizeOption(String size) {
    bool isSelected = _selectedSize == size;
    if (isSelected) {
      _selectedSize = size;
      _selectedColor = ''; // Xóa màu đã chọn khi kích thước bị hủy chọn
      _selectedProductListSize = productList.firstWhere(
        (productListSize) => productListSize.sizeId?.name == _selectedSize,
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedSize = '';
            _selectedColor = ''; // Xóa màu đã chọn khi kích thước bị hủy chọn
          } else {
            _selectedSize = size;
          }
          print('Kích thước đã chọn: $_selectedSize');
          updateSizeList(); // Cập nhật danh sách màu khi kích thước được chọn
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

  Widget _buildColorOption(String color) {
    bool isSelected = _selectedColor == color;
    if (isSelected) {
      _selectedColor = color;
      _selectedProductListSize = productList.firstWhere(
        (productListSize) =>
            productListSize.sizeId?.name == _selectedSize &&
            productListSize.colorId?.name == _selectedColor,
      );
      updateMaxQuantity(); // Gọi hàm để cập nhật số lượng khi màu được chọn
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedColor = '';
          } else {
            _selectedColor = color;
            quantity = 0; // Đặt lại quantity thành 0 khi chọn màu mới
          }
          print('Màu đã chọn: $_selectedColor');
        });
      },
      child: Container(
        width: 100,
        height: 47,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6342E8) : Color(0xFFF1F4FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            color,
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
    if (_selectedProductListSize != null &&
        _selectedProductListSize?.quantity != null &&
        quantity < _selectedProductListSize!.quantity!) {
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
                  color: Color.fromARGB(255, 198, 198, 198),
                  child: PageView.builder(
                    itemCount: widget.productfvr?.productId?.image?.length ?? 0,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        widget.productfvr?.productId?.image?.elementAt(index) ??
                            '',
                        fit: BoxFit.cover,
                      );
                    },
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
                                flex: 7,
                                child: Text(
                                  widget.productfvr?.productId?.name ??
                                      'Unknown Product Name',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '\$${widget.productfvr?.productId?.price ?? 0.00}',
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
                                Icons.star_half,
                                color: Colors.yellow,
                                size: 15,
                              ),
                              Icon(
                                Icons.star_border_outlined,
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
                                widget.productfvr?.productId?.description ??
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
                                children: _selectedSize.isEmpty
                                    ? getUniqueSizes().map((size) {
                                        return _buildSizeOption(size);
                                      }).toList()
                                    : colorList.map((color) {
                                        return _buildColorOption(color);
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
                                if (_selectedProductListSize != null) {
                                  print(
                                      'idsizecolor : ${_selectedProductListSize?.sId}');

                                  addToCart(
                                      _selectedProductListSize?.sId ?? '', 1);
                                } else {
                                  print('No size and color selected');
                                }

                                // call api add cart
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
