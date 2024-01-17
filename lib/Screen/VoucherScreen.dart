import 'dart:convert';

import 'package:appclient/Widgets/loading.dart';
import 'package:appclient/Widgets/voucheritem.dart';
import 'package:appclient/models/voucherModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  List<Listdiscount> vouchers = [];
  Future<void> fetchVouchers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? idUser = prefs.getString("idUser");

    if (idUser == null) {
      print('User id is null. Please log in first.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$BASE_API/api/discount/$idUser'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('listdiscount')) {
          final List<dynamic> listDiscountData = responseData['listdiscount'];

          setState(() {
            vouchers = listDiscountData
                .map((item) => Listdiscount.fromJson(item))
                .toList();
          });
        } else {
          print('Key listdiscount not found in JSON response');
        }
      } else {
        print(
            'Fetch vouchers API call failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error calling Fetch vouchers API: $error');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVouchers();
  }

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
          'Voucher',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: Stack(
        children: [
          vouchers.isNotEmpty ?
          Container(
            padding: EdgeInsets.all(18),
            child: ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                final voucher = vouchers[index];
                return voucheritem(voucher: voucher);
              },
            ),
          ) :
          SizedBox(
              height: double.infinity,
              child: Center(
                  child: Image.asset('lib/images/empty-box.png' , width: 200 , height: 200,
                  )
              )
          ),
          vouchers.isEmpty ? Center(child: showLoading()) : const SizedBox()
        ],
      )
    );
  }
}
