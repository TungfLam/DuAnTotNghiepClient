import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text('Adadas',style: TextStyle(fontWeight: FontWeight.bold),), // Tiêu đề của ứng dụng
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined), // Biểu tượng tìm kiếm
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng tìm kiếm
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined), // Biểu tượng cài đặt
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng cài đặt
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border_outlined), // Biểu tượng thông báo
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng thông báo
            },
          ),
          IconButton(
            icon: Icon(Icons.search_outlined), // Biểu tượng tài khoản
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng tài khoản
            },
          ),
          IconButton(
            icon: Icon(Icons.menu_outlined), // Biểu tượng menu
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng menu
            },
          ),
        ],
        // Đặt màu nền của AppBar
        backgroundColor: Colors.white, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          color: Colors.amber,
          child: Center(child: Text("List product")),
        ),
      ),
    );
  }
}