import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
          'Phương thức thanh toán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(height: 10),

                SizedBox(height: 10),
                Image.asset(
                  'lib/images/cod.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(height: 10),
                Text(
                  'Thanh toán khi nhân hàng',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
             Row(
              children: [
                SizedBox(height: 10),

                SizedBox(height: 10),
                Image.asset(
                  'lib/images/vnpay.png',
                  width: 30,
                  height: 30,
                ),
                SizedBox(height: 10),
                Text(
                  'Thanh toán bằng vnpay',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Arial',
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
