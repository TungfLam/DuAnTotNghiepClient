import 'package:flutter/material.dart';

class voucheritem extends StatelessWidget {
  final voucher;

  const voucheritem({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image(
                image: AssetImage('lib/images/voucher.png'),
                height: 80,
                fit: BoxFit.cover,
              ),
              Text(
                voucher.description ?? 'No description',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF6342E8), // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/');
                  },
                  child: Text('sử dụng'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
