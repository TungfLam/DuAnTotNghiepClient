import 'package:appclient/Screen/Billone.dart';
import 'package:flutter/material.dart';

class BillAllScreen extends StatefulWidget {
  const BillAllScreen({Key? key}) : super(key: key);

  @override
  State<BillAllScreen> createState() => _BillAllScreenState();
}

class _BillAllScreenState extends State<BillAllScreen> {
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
          'Đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Chờ xác nhận'),
                Tab(text: 'Chờ giao hàng'),
                Tab(text: 'Đã giao'),
                Tab(text: 'Đã hủy'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xff6342E8),
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Nội dung cho tab "Chờ xác nhận"
                  Container(child: Billone()),
                  // Nội dung cho tab "Chờ giao hàng"
                  Container(
                    child: const Center(
                      child: Text('  Chờ giao hàng  '),
                    ),
                  ),
                  // Nội dung cho tab "Đánh giá"
                  Container(
                    child: const Center(
                      child: Text('  Đánh giá  '),
                    ),
                  ),
                  Container(
                    child: const Center(
                      child: Text('  Đã hủy  '),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
