import 'package:flutter/material.dart';

import 'Product.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<Product> products = [
    Product(
        name: 'Pink Hoodie',
        price: '100 USD',
        imageUrl: 'lib/images/hoodie2.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '75 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '50 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    Product(
        name: 'Pink Hoodie',
        price: '100 USD',
        imageUrl: 'lib/images/hoodie2.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '75 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '50 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '50 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    Product(
        name: 'Pink Hoodie',
        price: '100 USD',
        imageUrl: 'lib/images/hoodie2.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '75 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    Product(
        name: 'Light Purple Hoodie',
        price: '50 USD',
        imageUrl: 'lib/images/hoodie1.png'),
    // Thêm nhiều sản phẩm khác vào danh sách products
  ];

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
              Navigator.pushNamed(context, '/detaiproduct');
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
                                padding: const EdgeInsets.only(top: 10),
                                child: Image.asset(
                                  product.imageUrl,
                                  height: 200,
                                  width: 180,
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: IconButton(
                                  icon: Icon(
                                    product.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      product.isFavorite = !product.isFavorite;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
                              product.price,
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
            ));
      },
    );
  }
}
