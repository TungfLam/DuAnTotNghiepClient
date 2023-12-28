import 'dart:convert';

import 'package:appclient/Screen/Comment/AllComment.dart';
import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/itemComment.dart';
import 'package:appclient/Widgets/showStar.dart';
import 'package:appclient/models/comment.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:appclient/models/productFvoriteModel.dart';
import 'package:appclient/models/productModel.dart';
import 'package:appclient/models/productSizeColor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct(
      {Key? key, required this.title, this.product, this.productfvr})
      : super(key: key);
  final String title;
  final productModel? product;
  final ListFavorite? productfvr;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  String _selectedSize = '';
  String _selectedColor = ''; // Biến lưu kích thước đã chọn
  List<ProductListSize> productList = [];
  List<String> sizeList = [];
  List<String> colorList = [];
  List arrComment = [];
  int maxQuantity = 0;
  int quantity = 0;
  int _selectedImageIndex = 0;
  ProductListSize? _selectedProductListSize;
  String? _selectedProductListSizeId;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductList();
    // arrComment.add(Comment(sId: "6558d4bcc1ab8c3f98265386" , productId: "65785ed034b7645148ab9f0a",
    //   userId: "6524318746e12608b3558d74",comment: "em dep lam2",rating: 4 ,date: "123456" , images: ["$BASE_API/avatas/6524318746e12608b3558d74_images.jpg" , "$BASE_API/avatas/6524318746e12608b3558d74_images.jpg" ]));
    // setState(() {
    //
    // });
    if(widget.product != null){
      getComment();
    }

  }

  void incrementQuantity() {
    productList.forEach((productListSize) {
      if (_selectedSize == productListSize.sizeId?.name &&
          _selectedColor == productListSize.colorId?.name) {
        setState(() {
          maxQuantity = productListSize.quantity!;
          if (selectedQuantity < maxQuantity) {
            selectedQuantity++;
          }
        });
      }
    });
  }

  void decrementQuantity() {
    if (selectedQuantity > 1) {
      setState(() {
        selectedQuantity--;
      });
    }
  }

  void updateSizeList() {
    sizeList.clear();
    productList.forEach((productListSize) {
      if (productListSize.colorId?.name == _selectedColor) {
        sizeList.add('${productListSize.sizeId?.name}');
      }
    });
  }

  void _showSizeColorModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            // Nội dung của ModalBottomSheet ở đây
            padding: EdgeInsets.fromLTRB(20, 35, 20, 20),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          width: 40,
                          height: 80,
                          child: Image.network(
                              widget.product?.image?.elementAt(0) ?? '',
                              fit: BoxFit.cover, errorBuilder:
                                  (BuildContext context, Object error,
                                      StackTrace? stackTrace) {
                            return Center(child: const Icon(Icons.image));
                          }),
                        )),
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.product?.name ?? 'Unknown Product Name',
                            ),
                            Text(
                              '${NumberFormat.decimalPattern().format(widget.product?.price ?? 0.00)} đ',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Text("Màu sắc"),
                Container(
                  height: 35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colorList
                        .toSet()
                        .length, // Sử dụng toSet() để loại bỏ các màu sắc trùng lặp
                    itemBuilder: (context, index) {
                      String uniqueColor = colorList.toSet().elementAt(index);
                      // Lấy màu sắc duy nhất từ danh sách không trùng lặp

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = uniqueColor;
                            selectedQuantity = 1;

                            // Khi chọn màu sắc mới, cập nhật danh sách kích thước tương ứng
                            updateSizeList();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: _selectedColor == uniqueColor
                                ? Color(0xFF6342E8)
                                : Colors.grey[300],
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 30,
                          child: Center(
                            child: Text(
                              uniqueColor,
                              style: TextStyle(
                                color: _selectedColor == uniqueColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text("Size"),
                Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sizeList
                        .toSet()
                        .length, // Sử dụng toSet() để loại bỏ các kích thước trùng lặp
                    itemBuilder: (context, index) {
                      String uniqueSize = sizeList.toSet().elementAt(index);
                      // Lấy kích thước duy nhất từ danh sách không trùng lặp

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = uniqueSize;
                            selectedQuantity = 1;
                          });
                        },
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: _selectedSize == uniqueSize
                                ? Color(0xFF6342E8)
                                : Colors.grey[300],
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Center(
                            child: Text(
                              uniqueSize,
                              style: TextStyle(
                                color: _selectedSize == uniqueSize
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Số lượng"),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    decrementQuantity();
                                  });
                                },
                                icon: Icon(Icons.remove),
                              ),
                              Text(
                                selectedQuantity.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    incrementQuantity();
                                  });
                                },
                                icon: Icon(Icons.add),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_selectedSize.isNotEmpty &&
                            _selectedColor.isNotEmpty) {
                          productList.forEach((productListSize) {
                            if (_selectedSize == productListSize.sizeId?.name &&
                                _selectedColor ==
                                    productListSize.colorId?.name) {
                              setState(() {
                                maxQuantity = productListSize.quantity!;
                                _selectedProductListSizeId =
                                    productListSize.sId;
                              });
                            }
                          });

                          print('Selected Size: $_selectedSize');
                          print('Selected Color: $_selectedColor');
                          print(
                              'Selected ProductListSizeId: $_selectedProductListSizeId');

                          // Thử thêm vào giỏ hàng
                          bool addToCartSuccess = await addToCart(
                              '$_selectedProductListSizeId', selectedQuantity);

                          if (addToCartSuccess) {
                            // Nếu thêm vào giỏ hàng thành công, hiển thị thông báo và cung cấp tùy chọn chuyển đến giỏ hàng
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(child: Text('Thông Báo')),
                                  content: Text(
                                      'Sản phẩm đã được thêm vào giỏ hàng.'),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Đóng'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Điều hướng đến màn hình giỏ hàng
                                            Navigator.of(context)
                                                .pop(); // Đóng hộp thoại hiện tại trước khi điều hướng
                                            Navigator.pushNamed(context,
                                                '/mycart'); // Thay đổi '/cart' bằng định tuyến thích hợp
                                          },
                                          child: Text('Đến Giỏ Hàng'),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          // ... (các xử lý khác nếu cần)
                        } else {
                          // Hiển thị thông báo nếu chưa chọn size hoặc color
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(child: Text('Xin Lỗi')),
                                content: Text(
                                    'Vui lòng chọn kích thước và màu sắc.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ), // Icon tùy chọn
                      label: const Text(
                        'Thêm vào giỏ hàng',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6342E8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  Future<void> fetchProductList() async {
    try {
      // final response = await http.read(
      //   Uri.parse(

      //     '$BASE_API/api/getListAll_deltail/${widget.product?.sId}',

      //   ),
      final response = await http.read(
        Uri.parse(
          'https://adadas.onrender.com/api/getListAll_deltail/${widget.product?.sId}',
        ),
        headers: {'Content-Type': 'application/json'},
      );

      final List<dynamic> data = json.decode(response)['productListSize'];

      if (mounted) {
        setState(() {
          productList =
              data.map((item) => ProductListSize.fromJson(item)).toList();
        });
      }

      sizeList.clear();
      colorList.clear();

      productList.forEach((productListSize) {
        // print('Quantity: ${productListSize.quantity}');
        // print('Quantity: ${productListSize.sizeId?.name}');
        // print('idsizecolor : ${productListSize.sId}');
        sizeList.add('${productListSize.sizeId?.name}');
        colorList.add('${productListSize.colorId?.name}');
        if (_selectedSize == productListSize.sizeId?.name &&
            _selectedColor == productListSize.colorId?.name) {
          setState(() {
            maxQuantity = productListSize.quantity!;
            _selectedProductListSizeId = productListSize.sId;
          });
        }
      });
    } catch (error) {
      print('Error fetching product list: $error');
    }
  }

  Future<bool> addToCart(String productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://adadas.onrender.com/api/addCart/6524318746e12608b3558d74/$productId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode == 200) {
        // Xử lý khi thành công
        print('Added to cart successfully!');
        return true; // Trả về true nếu thành công
      } else {
        // Xử lý khi không thành công
        print('Failed to add to cart. Status code: ${response.statusCode}');
        return false; // Trả về false nếu không thành công
      }
    } catch (error) {
      // Xử lý khi có lỗi
      print('Error adding to cart: $error');
      return false; // Trả về false nếu có lỗi
    }
  }

  Future<void> getComment() async {
    final response = await http.get(
        Uri.parse("$BASE_API/api/comment/${widget.product!.sId}?count=4"));

    if (response.statusCode == 200) {
      final data = await json.decode(response.body);
      arrComment = data;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 400,
                    color: const Color.fromARGB(255, 198, 198, 198),
                    child: PageView.builder(
                      itemCount: widget.product?.image?.length ?? 0,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.product?.image?.elementAt(index) ?? "",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        // borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                      ),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Text(
                                widget.product?.name ?? 'Unknown Product Name',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                '${NumberFormat.decimalPattern().format(widget.product?.price ?? 0.00)} đ',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        showStar(countStar: 5),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Descripsion: ",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.product?.description ??
                                    'Unknown Product Name',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Đáng giá",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            )),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 8),
                          child: Column(
                            children: arrComment
                                .map((e) => itemComment(item: e))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AllComment.nameComment);
                            },
                            child: const Text(
                              "Xem tất cả bình luận",
                              style: TextStyle(fontSize: 18),
                            )),
                        const SizedBox(height: 56)
                      ])),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Xử lý khi nhấn nút back
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  // Xử lý khi nhấn nút favorite
                },
              ),
            ),
          ),
          Positioned(
              child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final bool? isLogin = prefs.getBool("isLogin");
                  final String? idUser = prefs.getString("idUser");
                  if (isLogin != null) {
                    if (isLogin == true) {
                      print("người dùng đã login");
                      _showSizeColorModal(context);
                    } else if (isLogin == false) {
                      Navigator.pushNamed(context, '/login');
                    }
                  }
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ), // Icon tùy chọn
                label: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6342E8), // Đặt màu nền
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
