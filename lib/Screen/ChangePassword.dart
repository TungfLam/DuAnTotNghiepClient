import 'dart:convert';

import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPage();
  }
}

class ChangePasswordPage extends State<ChangePassword> {
  final form = FormGroup({
    'CurrentPassword': FormControl<String>(
      validators: [Validators.required],
    ),
    'Password': FormControl<String>(
      validators: [
        Validators.required,
        Validators.minLength(8),
        Validators.pattern(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$')
      ],
    ),
    'Repassword': FormControl<String>(
      validators: [
        Validators.required,
      ],
    ),
  });

  var checkPass = false;

  Future<void> _callChangePassword(BuildContext context, String id,
      String password, String newPassword) async {
    final response = await http.put(
        Uri.parse("https://adadas.onrender.com/api/change-password/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'password': password,
          'newPassword': newPassword
        }));

    if (response.statusCode == 200) {
      Map<String, dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if (!res.err!) {
        showSnackBar(context, res.msg!);
      } else {
        if (res.msg == 'Tài khoản chưa có mật khẩu') {
          showDialogUilt(context, 'Thông báo', res.msg!, () {});
        } else if (res.msg == "Không thành công, vui long thử lại sau") {
          showDialogUilt(context, 'Thông báo', res.msg!, () {});
        } else if (res.msg == "Mật khẩu không chính xác") {
          showDialogUilt(context, 'Thông báo', res.msg!, () {});
        } else {
          showSnackBarErr(context, res.msg!);
        }
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              centerTitle: true,
              elevation: 0,
            ),
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 23),
              child: SingleChildScrollView(
                  child: ReactiveFormBuilder(
                      form: () => form,
                      builder: (context, _, __) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 18),
                              child: const Text(
                                'Mật khẩu hiện tại',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            ReactiveTextField<String>(
                              formControlName: 'CurrentPassword',
                              decoration: const InputDecoration(
                                  labelText: 'Mật khẩu hiện tại',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20.0)),
                              onChanged: (value) {},
                              style: const TextStyle(fontSize: 18.0),
                              obscureText: true,
                              validationMessages: {
                                'required': (error) =>
                                    'Mật khẩu hiện tại không được để trống'
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 18),
                              child: const Text(
                                'Mật khẩu mới',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            ReactiveTextField<String>(
                              formControlName: 'Password',
                              decoration: const InputDecoration(
                                  labelText: 'Nhập mật khẩu mới của bạn',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20.0)),
                              onChanged: (value) {},
                              style: const TextStyle(fontSize: 18.0),
                              obscureText: true,
                              validationMessages: {
                                'required': (error) =>
                                    'Mật khẩu mới không được để trống',
                                'minLength': (error) =>
                                    'Mật khẩu phải có ít nhất 8 ký tự',
                                'pattern': (error) =>
                                    'Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường và một số',
                              },
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 18),
                              child: const Text(
                                'Nhập lại mật khẩu',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            ReactiveTextField<String>(
                              formControlName: 'Repassword',
                              decoration: const InputDecoration(
                                  labelText: 'Nhập lại mật khẩu',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20.0)),
                              onChanged: (value) {},
                              style: const TextStyle(fontSize: 18.0),
                              obscureText: true,
                              validationMessages: {
                                'required': (error) => 'Nhập lại mật khẩu'
                              },
                            ),
                            if (checkPass)
                              Container(
                                margin: const EdgeInsets.only(left: 20, top: 8),
                                child: const Text(
                                  "Mật khẩu nhập lại không chính xác",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                              ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              child: const Text(
                                'Cách tạo mật khẩu:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: const Text(
                                ' Chứa ít nhất 8 ký tự',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: const Text(
                                ' Chứa cả chữ thường (a-z) và chữ hoa (A-Z)',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 40),
                              child: const Text(
                                ' Chứa cả số (0-9)',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6342E8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                onPressed: () {
                                  form.markAllAsTouched();
                                  if (form.valid) {
                                    if (form.control('Password').value !=
                                        form.control("Repassword").value) {
                                      setState(() {
                                        checkPass = true;
                                      });
                                    } else {
                                      setState(() {
                                        checkPass = false;
                                      });
                                      _callChangePassword(
                                          context,
                                          '6524318746e12608b3558d74',
                                          form.control('CurrentPassword').value,
                                          form.control('Password').value);
                                    }
                                  }
                                },
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
                        );
                      })),
            )));
  }
}
