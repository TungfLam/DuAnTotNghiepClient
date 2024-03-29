// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:appclient/Listview/DiscountProductList.dart';
import 'package:appclient/Listview/MensProductList.dart';
import 'package:appclient/Listview/PopularProductList.dart';
import 'package:appclient/Listview/WomensProductList.dart';
import 'package:appclient/Widgets/loading.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:appclient/services/firebaseAuthService.dart';
import 'package:appclient/services/notification_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  String _inout = "Đăng nhập";
  String anhdd = '';
  String mail = '';
  String fname = '';
  String _idUser = '';
  String phone = '';
  var subscription;
  bool _isLoading = false;

  Future<void> _checkLogin() async {
    final connecting = await (Connectivity().checkConnectivity());
    if(connecting == ConnectivityResult.none) {
      showDialogUilt15(context, "Lỗi kết nối", "Mất kết nối internet , vui lòng kiểm tra lại", (){
        Navigator.of(context).pop();
        SystemNavigator.pop();
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    final String? avarta = prefs.getString("avata");
    final String? email = prefs.getString("email");
    final String? fullname = prefs.getString("fullname");
    phone = prefs.getString('phone')!;


    print('$email');
    print('$avarta');
    print('$fullname');

    anhdd = avarta ?? '';
    mail = email ?? '';
    fname = fullname ?? '';
    _idUser = idUser ?? '';

    await prefs.setBool("isDone", true);
    String deviceId = await _authService.getDeviceId(context);

    if (isLogin == null) {
      setState(() {
        _inout = "Đăng nhập";
        _isLoading = false;
      });
      return;
    }

    if (isLogin) {
      setState(() {
        _inout = "Đăng xuất";
      });
      final response = await http.post(
          Uri.parse("$BASE_API/api/cheklogin/$idUser"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(<String, String>{'deviceId': deviceId}));

      if (response.statusCode == 200) {
        Map<String, dynamic> apiRes = jsonDecode(response.body);
        ApiRes res = ApiRes.fromJson(apiRes);

        if (res.err!) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Thông báo"),
                  content: Text("${res.msg}, đăng xuất"),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          await prefs.clear();
                          Navigator.of(context).pop();
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (Route<dynamic> route) => false);
                        },
                        child: const Text("OK"))
                  ],
                );
              });
        }
      }
    } else {
      setState(() {
        _inout = "Đăng nhập";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<bool> logoutUser(String idUser) async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(Uri.parse("$BASE_API/api/logout/$idUser"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    if (response.statusCode == 200) {
      Map<String, dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if (res.err!) {
        showSnackBarErr(context, "${res.msg}");
      } else {
        setState(() {
          _isLoading = false;
        });
        return true;
      }
    } else {
      showSnackBarErr(context, "Lỗi Api");
    }
    setState(() {
      _isLoading = false;
    });
    return false;
  }



  @override
  void initState() {
    super.initState();
    _checkLogin();

    LocalNotifications2.onClickNotification.listen((value) {
      print("kkkkkkkkk : $value");
      Navigator.pushNamed(context, '/notification');
    });

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(result == ConnectivityResult.none){
        showDialogUilt15(context, "Lỗi kết nối", "Mất kết nối internet , vui lòng kiểm tra lại", (){
            Navigator.of(context).pop();
            exit(0);
        });
      }else{
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialogUilt2(context, "Thông báo", "Bạn có muốn thoát", (){
          exit(0);
        });
        return false;
      },
      child: DefaultTabController(
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
                  Navigator.pushNamed(context, '/notification');
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
          body: Stack(
            children: [
              TabBarView(
                // Nội dung của các tab
                children: [
                  // Nội dung của Tab 1
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const PopularProductList(),
                  ),
                  // Nội dung của Tab 2
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const MensProductList(),
                  ),
                  // Nội dung của Tab 3
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const WomensProductList(),
                  ),
                  // Nội dung của Tab 4
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const DiscountScreen(),
                  ),
                ],
              ),

              _isLoading ? const showLoading() : const SizedBox()
            ],
          ),
          endDrawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');

                    },
                    child: Row(
                      children: [

                        if (anhdd != '')
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: ClipOval(
                              child: Image(
                                height: 60,
                                width: 60,
                                image: NetworkImage('$BASE_API$anhdd'),
                                errorBuilder: (BuildContext context, Object error,
                                    StackTrace? stackTrace) {
                                  return const Center(child: Icon(Icons.image));
                                },
                              ),
                            ),
                          ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              fname ?? 'tên người dùng không tồn tại',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              phone,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_bag_outlined),
                  title: const Text(
                    'Giỏ hàng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/mycart');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: const Text(
                    'Yêu thích',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/favorite');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.blinds_closed_outlined),
                  title: const Text(
                    'Đơn hàng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/bill');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text(
                    'Địa chỉ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (_inout == "Đăng xuất") {
                      Navigator.pushNamed(context, '/location');
                    } else {
                      showDialogUilt(context, "Thông báo",
                          "Bạn chưa đăng nhận, vui lòng đăng nhập để sử dụng tính năng này",
                          () {
                        print("object");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                        print("object");
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.payment_outlined),
                  title: const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (_inout == "Đăng xuất") {
                      Navigator.pushNamed(context, '/payment');
                    } else {
                      showDialogUilt(context, "Thông báo",
                          "Bạn chưa đăng nhận, vui lòng đăng nhập để sử dụng tính năng này",
                          () {
                        print("object");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                        print("object");
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.discount_outlined),
                  title: const Text(
                    'Voucher',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (_inout == "Đăng xuất") {
                      Navigator.pushNamed(context, '/voucher');
                    } else {
                      showDialogUilt(context, "Thông báo",
                          "Bạn chưa đăng nhận, vui lòng đăng nhập để sử dụng tính năng này",
                          () {
                        print("object");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                        print("object");
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text(
                    'Thông báo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (_inout == "Đăng xuất") {
                      Navigator.pushNamed(context, '/notification');
                    } else {
                      showDialogUilt(context, "Thông báo",
                          "Bạn chưa đăng nhận, vui lòng đăng nhập để sử dụng tính năng này",
                          () {
                        print("object");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                        print("object");
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.chat_bubble_outline_outlined),
                  title: const Text(
                    'Hỗ trợ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    if (_inout == "Đăng xuất") {
                      Navigator.pushNamed(context, '/chat');
                    } else {
                      showDialogUilt(context, "Thông báo",
                          "Bạn chưa đăng nhận, vui lòng đăng nhập để sử dụng tính năng này",
                          () {
                        print("object");
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/login');
                        print("object");
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ListTile(
                    leading: Icon((_inout == "Đăng xuất"
                        ? Icons.logout_outlined
                        : Icons.login_outlined)),
                    title: Text(
                      _inout,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () async {
                      if (_inout == "Đăng xuất") {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? idUser = prefs.getString("idUser");
                        await logoutUser(idUser!);
                        prefs.clear();
                        await prefs.setBool("isLogin", false);
                        FirebaseAuth.instance.signOut();
                      }

                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
