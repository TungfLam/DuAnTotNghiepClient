// import 'package:flutter/material.dart';

// import 'Product.dart';

// class ProductList extends StatefulWidget {
//   const ProductList({super.key});

//   @override
//   _ProductListState createState() => _ProductListState();
// }

// class _ProductListState extends State<ProductList> {
//   List<Product> products = [
//     Product(
//         name: 'Pink Hoodie',
//         price: '100 USD',
//         imageUrl: 'lib/images/hoodie2.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '75 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '50 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     Product(
//         name: 'Pink Hoodie',
//         price: '100 USD',
//         imageUrl: 'lib/images/hoodie2.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '75 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '50 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '50 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     Product(
//         name: 'Pink Hoodie',
//         price: '100 USD',
//         imageUrl: 'lib/images/hoodie2.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '75 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     Product(
//         name: 'Light Purple Hoodie',
//         price: '50 USD',
//         imageUrl: 'lib/images/hoodie1.png'),
//     // Thêm nhiều sản phẩm khác vào danh sách products
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 8,
//         mainAxisSpacing: 8,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: products.length,
//       itemBuilder: (context, index) {
//         final product = products[index];

//         return GestureDetector(
//             onTap: () {
//               // Xử lý khi bạn click vào item
//               print('Bạn đã click vào sản phẩm: ${product.name}');
//               Navigator.pushNamed(context, '/detaiproduct');
//             },
//             child: Card(
//               color: Colors.white,
//               shadowColor: Colors.black,
//               elevation: 10,
//               child: SizedBox(
//                 child: Stack(
//                   children: [
//                     Column(
//                       children: [
//                         Expanded(
//                           flex: 4,
//                           child: Stack(
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: Image.asset(
//                                   product.imageUrl,
//                                   height: 200,
//                                   width: 180,
//                                 ),
//                               ),
//                               Positioned(
//                                 top: 5,
//                                 right: 5,
//                                 child: IconButton(
//                                   icon: Icon(
//                                     product.isFavorite
//                                         ? Icons.favorite
//                                         : Icons.favorite_border,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       product.isFavorite = !product.isFavorite;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             child: Text(
//                               product.name,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: Container(
//                             padding: EdgeInsets.only(bottom: 10),
//                             child: Text(
//                               product.price,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: Color.fromARGB(255, 105, 105, 105),
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ));
//       },
//     );
//   }
// }
// import 'package:flutter/material.dart';
import 'package:appclient/Screen/DetailProduct.dart';
import 'package:appclient/models/productModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<productModel> products = []; // Danh sách sản phẩm từ API

  // Hàm để gọi API và cập nhật danh sách sản phẩm
  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'http://192.168.45.108:6868/api/products/')); // Thay thế URL của API sản phẩm
    if (response.statusCode == 200) {
      final List<dynamic> productData = jsonDecode(response.body);
      setState(() {
        products =
            productData.map((item) => productModel.fromJson(item)).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Gọi API khi widget được khởi tạo
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        return GestureDetector(
          onTap: () {
            // Xử lý khi bạn click vào item
            print('Bạn đã click vào sản phẩm: ${product.name}');
            // Navigator.pushNamed(context, '/detaiproduct');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailProduct(
                  title: 'Chi tiết sản phẩm',
                  product: product, // Truyền đối tượng sản phẩm đã được chọn
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
                                base64Decode(product.image?.elementAt(0) ??
                                    ''), // Giả sử danh sách ảnh là danh sách base64
                                height: 200,
                                width: 180,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                icon: Icon(Icons.favorite_border_outlined),
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
                      ),
                      SizedBox(width: 8),
                      IconButton(
                          onPressed: () async {
                            final response = await http.post(
                              Uri.parse(
                                  'http://localhost:6868/api/addFavorite/iduser/id_product'),
                              body: jsonEncode({
                                'id_product': product.sId,
                              }),
                            );
                            if (response.statusCode == 200) {
                              setState(() {
                                product.isFavorite = true;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.favorite,
                            color:
                                product.isFavorite! ? Colors.red : Colors.grey,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ {}
