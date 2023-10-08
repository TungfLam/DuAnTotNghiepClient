import 'package:flutter/material.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Xử lý khi người dùng nhấn nút back
          },
        ),
        title: Text(
          'Favorite',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              color: Colors.amber,
              width: double.infinity,
              height: 620,
              child: Text("data"),
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
                    // Xử lý khi nút được nhấn
                  },
                  icon: Icon(Icons.shopping_cart,color: Colors.white,), // Icon tùy chọn
                  label: Text('ADD ALL TO CART',style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6342E8), // Đặt màu nền
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
