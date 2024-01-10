import 'package:appclient/models/productCartModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayScreen extends StatefulWidget {
  final int totalAmount;
  final List<String> idcart;
  final String userid;
  final String idDiscount;
  const PayScreen(
      {Key? key,
      required String title,
      required this.totalAmount,
      required this.idcart,
      required this.userid, required this.idDiscount})
      : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late final WebViewController _controller;
  late Future<void> _createPaymentFuture;
  String _uriPay = '';

  Future<void> createPayment() async {
    // const apiUrl = '$BASE_API/order/create_payment_url/$idcart';
    final apiUrl =
        'https://adadas.onrender.com/order/create_payment_url/${widget.userid}';
    final requestData = {
      "idCart": widget.idcart,
      "amount": widget.totalAmount,
      "idDiscount":widget.idDiscount,
      "language": "vi"
    };
    final headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'connect.sid=s%3AGOomxkPMZ7_8pNTgL7RxMaHQHJ93Vli8.v9IC4cc1ExSIjV3tZTjQkwF1%2Bz83TynXg5Q6qgRoI%2FE'
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final vnpUrl = responseData['vnpUrl'];

        if (vnpUrl != null) {
          if (!vnpUrl.startsWith('http')) {
            setState(() {
              _uriPay = 'https://' + vnpUrl;
            });
          } else {
            setState(() {
              _uriPay = vnpUrl;
            });
          }
          print('API Response zzzz: $_uriPay');
        }
        print('API Response: $responseData');
      } else {
        print('API Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // print('ProductId from MyCart: ${widget.productId}');
    print('tổng tiền: ${widget.totalAmount}');
    print('id cart: ${widget.idcart}');
    _createPaymentFuture = createPayment();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);
  }

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
          'Thanh toán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: FutureBuilder(
        future: _createPaymentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _controller.loadRequest(Uri.parse(_uriPay));
          }
          return WebViewWidget(controller: _controller);
        },
      ),
    );
  }
}
