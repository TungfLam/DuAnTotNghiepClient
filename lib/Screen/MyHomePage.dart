import 'package:appclient/Listview/MensProductList.dart';
import 'package:appclient/Listview/PopularProductList.dart';
import 'package:appclient/Listview/WomensProductList.dart';
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          bottom: const TabBar(
            // Thanh TabBar ở đây
            tabs: [
              Tab(text: 'Phổ biến'),
              Tab(text: 'Nam'),
              Tab(text: 'Nữ'),
              Tab(text: 'Khiến mại'),
            ],
          ),
        ),
        body: TabBarView(
          // Nội dung của các tab
          children: [
            // Nội dung của Tab 1
            Container(
              padding: EdgeInsets.all(20),
              child: PopularProductList(),
            ),
            // Nội dung của Tab 2
            Container(
              padding: EdgeInsets.all(20),
              child: MensProductList(),
            ),
            // Nội dung của Tab 3
            Container(
              padding: EdgeInsets.all(20),
              child: WomensProductList(),
            ),
            // Nội dung của Tab 4
            Center(child: Text('Khuyến mãi')),
          ],
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
                          height: 60,
                          width: 60,
                          image: AssetImage('lib/images/img2.jpg'),
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
                leading: const Icon(Icons
                    .shopping_bag_outlined), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'Giỏ hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/mycart');
                  // Xử lý khi người dùng chọn Tùy chọn 1
                },
              ),
              ListTile(
                leading: const Icon(Icons
                    .favorite_border_outlined), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'Yêu thích',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/favorite');
                  // Xử lý khi người dùng chọn Tùy chọn 1
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.shopify_sharp), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'Đơn hàng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Xử lý khi người dùng chọn Tùy chọn 1
                  Navigator.pushNamed(context, '/bill');
                },
              ),
              ListTile(
                leading: const Icon(
                    Icons.location_on_outlined), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'Địa chỉ',
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
                  'Phương thức thanh toán',
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
                  'Khuyến mại',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Xử lý khi người dùng chọn Tùy chọn 1
                },
              ),
              ListTile(
                leading: const Icon(Icons
                    .notifications_outlined), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'Thông báo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Xử lý khi người dùng chọn Tùy chọn 1
                },
              ),
              ListTile(
                leading: const Icon(Icons
                    .help_outline_outlined), // Thêm biểu tượng vào ListTile
                title: const Text(
                  'Hỗ trợ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  // Xử lý khi người dùng chọn Tùy chọn 1
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //       Icons.error_outline), // Thêm biểu tượng vào ListTile
              //   title: const Text(
              //     'About',
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     // Xử lý khi người dùng chọn Tùy chọn 1
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListTile(
                  leading: const Icon(
                      Icons.logout_outlined), // Thêm biểu tượng vào ListTile
                  title: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    // Xử lý khi người dùng chọn Tùy chọn 1
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
              // Thêm nhiều ListTile khác cho các tùy chọn bổ sung
            ],
          ),
        ),
      ),
    );
  }
}
