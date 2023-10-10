import 'package:flutter/material.dart';

class Find extends StatefulWidget {
  const Find({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Find> createState() => _FindState();
}

class _FindState extends State<Find> {
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
                child: const Text("data find"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
