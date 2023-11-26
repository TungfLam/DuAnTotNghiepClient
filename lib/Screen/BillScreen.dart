// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class BillScreen extends StatefulWidget {
//   const BillScreen({Key? key}) : super(key: key);

//   @override
//   State<BillScreen> createState() => _BillScreenState();
// }

// class _BillScreenState extends State<BillScreen> {
//   late final WebViewController _controller;
//    String Uripay='';
//   Future<void> createPayment() async {
//   // Địa chỉ API và dữ liệu cần gửi
//   final apiUrl = 'https://adadas.onrender.com/order/create_payment_url';
//   final requestData = {
//     "amount": 1000000,
//     "language": "vi"
//   };

//   // Tiêu đề của yêu cầu
//   final headers = {
//     'Content-Type': 'application/json',
//     'Cookie': 'connect.sid=s%3A3hNpXbYJMrNPbnnjAl2Ep55ls4e3KN32.GTs8EHnEKqKK3SliELQ58JLAurSd1f0nWCtelkZFuBY'
//   };

//   try {
//     // Gửi yêu cầu POST
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: headers,
//       body: jsonEncode(requestData),
//     );

//     // Kiểm tra mã trạng thái của yêu cầu
//     if (response.statusCode == 200) {
//       // Xử lý dữ liệu nhận được từ API (response.body)
//       final responseData = jsonDecode(response.body);
//       final vnpUrl = responseData['vnpUrl'];
//         setState(() {
//           Uripay =  vnpUrl;
//           print('API Response zzzz: $Uripay');
//         });
//       print('API Response: $responseData');
//     } else {
//       // Xử lý khi có lỗi từ API
//       print('API Request failed with status: ${response.statusCode}');
//       print('Response body: ${response.body}');
//     }
//   } catch (error) {
//     // Xử lý khi có lỗi trong quá trình gửi yêu cầu
//     print('Error during API call: $error');
//   }
// }

//   @override
//   void initState() {
//     super.initState();

//     createPayment();

//     final WebViewController controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..loadRequest(Uri.parse('https://sandbox.vnpayment.vn/paymentv2/vpcpay.html?vnp_Amount=100000000&vnp_Command=pay&vnp_CreateDate=20231126061603&vnp_CurrCode=VND&vnp_IpAddr=1.55.112.130%2C+172.71.218.177%2C+10.210.234.55&vnp_Locale=vi&vnp_OrderInfo=Thanh+toan+cho+ma+GD%3A2023-11-26T06%3A16%3A03.844&vnp_OrderType=other&vnp_ReturnUrl=https%3A%2F%2Fadadas.onrender.com%2Forder%2Fvnpay_return&vnp_TmnCode=0DYTWAHH&vnp_TxnRef=2023-11-26T06%3A16%3A03.844&vnp_Version=2.1.0&vnp_SecureHash=de82c6420e03536ca59eeaa3dae4b68b5e829ae411430f8277a618431a179be1e832821985dd14e814bd1157828b204e09391522f7dc2f9a8c4877312e18f75a'));
//       _controller= controller;
//   }

  

//   @override
//   Widget build(BuildContext context) {
//     return WebViewWidget(controller: _controller);
//   }
// }
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late final WebViewController _controller;
  late Future<void> _createPaymentFuture;
  String _uriPay = '';

  Future<void> createPayment() async {
    // Địa chỉ API và dữ liệu cần gửi
    final apiUrl = 'https://adadas.onrender.com/order/create_payment_url';
    final requestData = {
      "amount": 1000000,
      "language": "vi"
    };

    // Tiêu đề của yêu cầu
    final headers = {
      'Content-Type': 'application/json',
      'Cookie': 'connect.sid=s%3A3hNpXbYJMrNPbnnjAl2Ep55ls4e3KN32.GTs8EHnEKqKK3SliELQ58JLAurSd1f0nWCtelkZFuBY'
    };

    try {
      // Gửi yêu cầu POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestData),
      );

      // Kiểm tra mã trạng thái của yêu cầu
      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ API (response.body)
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
        // Xử lý khi có lỗi từ API
        print('API Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      // Xử lý khi có lỗi trong quá trình gửi yêu cầu
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
    // return FutureBuilder(
    //   future: _createPaymentFuture,
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       _controller.loadRequest(Uri.parse(_uriPay));
    //     }
    //     return WebViewWidget(controller: _controller);
    //   },
    // );
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
