import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPage();
  }
}

class ChangePasswordPage extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: const Text(
                'Mật khẩu hiện tại',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              style: const TextStyle(fontSize: 13),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu hiện tại của bạn',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: const Color(0xFF6342E8))),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: const Text(
                'Mật khẩu mới',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              style: const TextStyle(fontSize: 13),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Nhập mật khẩu mới của bạn',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: const Color(0xFF6342E8))),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: const Text(
                'Nhập lại mật khẩu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            TextField(
              style: const TextStyle(fontSize: 13),
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Nhập lại mật khẩu mới của bạn',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: const Color(0xFF6342E8))),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Text(
                'Cách tạo mật khẩu:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                ' Chứa ít nhất 8 ký tự',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                ' Chứa cả chữ thường (a-z) và chữ hoa (A-Z)',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              child: const Text(
                ' Chứa cả số (0-9)',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6342E8),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                onPressed: () {},
                child: const Text(
                  'ĐẶT LẠI MẬT KHẨU',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
