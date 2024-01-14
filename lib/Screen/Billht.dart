import 'dart:convert';
import 'package:appclient/Widgets/Itembill.dart';
import 'package:appclient/models/productBillModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Billht extends StatefulWidget {
  @override
  _BillhtState createState() => _BillhtState();
}

class _BillhtState extends State<Billht> {
  Autogenerated? billData; // Dữ liệu bill sẽ được lưu ở đây

  @override
  Future<void> initState() async {
    super.initState();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    fetchData(idUser!);  // Gọi hàm fetchData khi widget được khởi tạo
  }

  Future<void> fetchData(String iduser) async {
    final apiUrl =
        'https://adadas.onrender.com/api/bill/$iduser';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Sử dụng lớp Autogenerated để giải mã dữ liệu JSON
        setState(() {
          billData = Autogenerated.fromJson(responseData);
        });

        // In ra dữ liệu ví dụ
        print('Status: ${billData!.status}');
        print('Message: ${billData!.msg}');
        // Xử lý các trường khác theo nhu cầu của bạn
      } else {
        print('API Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sử dụng dữ liệu trong cây widget
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Scaffold(
        body: billData == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: billData!.biilModel?.length ?? 0,
                itemBuilder: (context, index) {
                  final billItem = billData!.biilModel![index];

                  if (billItem.status == 7) {
                    return Itembill(billItem: billItem);
                  } else {
                    // Trả về một widget trống nếu không muốn hiển thị bill này
                    return SizedBox.shrink();
                  }
                },
              ),
      ),
    );
  }
}
