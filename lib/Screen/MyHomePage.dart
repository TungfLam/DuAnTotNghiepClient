import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Adadas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Xử lý khi người dùng nhấn vào biểu tượng thông báo
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/mycart');
              // Xử lý khi người dùng nhấn vào biểu tượng giỏ hàng
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/favorite');
              // Xử lý khi người dùng nhấn vào biểu tượng yêu thích
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/find');
              // Xử lý khi người dùng nhấn vào biểu tượng tìm kiếm
            },
          ),
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu_outlined),
                onPressed: () {
                  // Mở thanh điều hướng bên phải khi người dùng nhấp vào biểu tượng menu
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          color: Colors.amber,
          child: const Center(child: Text("Danh sách sản phẩm")),
        ),
      ),
      // Định nghĩa thanh điều hướng bên phải với các tùy chọn điều hướng
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color:
                    Colors.white, // Đặt màu nền của thanh điều hướng bên phải
              ),
              child: Row(
                children: [
                  // Thêm hình ảnh bên trái
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: ClipOval(
                      child: Image(
                        image:
                            NetworkImage("https://via.placeholder.com/60x60"),
                        width: 60, // Điều chỉnh kích thước hình ảnh
                        height: 60,
                      ),
                    ),
                  ),
                  // Thêm hai dòng văn bản bên phải
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Tên người dùng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'email người dùng @mail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // DrawerHeader(
            //   decoration: BoxDecoration(
            //     color: Colors.white, // Màu nền của thanh điều hướng bên phải
            //   ),
            //   child: Text('Thanh điều hướng'),
            // ),
            ListTile(
              leading: const Icon(
                  Icons.shopping_bag_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Cart',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(Icons
                  .favorite_border_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Favorite',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.location_on_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Delivery Address',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.payment_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Payment Methods',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.discount_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Promo Cord',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.notifications_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Notifecations',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.help_outline_outlined), // Thêm biểu tượng vào ListTile
              title: const Text(
                'Help',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            ListTile(
              leading: const Icon(
                  Icons.error_outline), // Thêm biểu tượng vào ListTile
              title: const Text(
                'About',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Xử lý khi người dùng chọn Tùy chọn 1
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: ListTile(
                leading: const Icon(
                    Icons.logout_outlined), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'LOGOUT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Xử lý khi người dùng chọn Tùy chọn 1
                },
              ),
            ),
            // Thêm nhiều ListTile khác cho các tùy chọn bổ sung
          ],
        ),
      ),
    );
  }
}
