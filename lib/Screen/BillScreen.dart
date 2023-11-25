import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse('https://sandbox.vnpayment.vn/paymentv2/Transaction/PaymentMethod.html?token=517d5721f00a4b3b9bc04c06503f9dc4'));
      _controller= controller;
  }

  

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
