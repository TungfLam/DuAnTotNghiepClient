
import 'package:appclient/models/productCartModel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  late final WebViewController _controller;
  late Future<void> _createPaymentFuture;
  String _uriPay = '';

  Future<void> createPayment() async {
    final apiUrl = 'https://adadas.onrender.com/order/create_payment_url/656f3ed50cf9116d0a07e0f8';
    final requestData = {
      "amount": 1000000,
      "language": "vi"
      
    };
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'connect.sid=s%3A3hNpXbYJMrNPbnnjAl2Ep55ls4e3KN32.GTs8EHnEKqKK3SliELQ58JLAurSd1f0nWCtelkZFuBY'
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

    _createPaymentFuture = createPayment();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);
  }

  @override
  Widget build(BuildContext context) {
        final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      final ListCart product = arguments['product'];
      print('id cart: ${product.sId}');

      // Sử dụng dữ liệu tại đây để hiển thị hoặc thực hiện các thao tác cần thiết
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Thanh toán')),
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
