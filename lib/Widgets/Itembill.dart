import 'dart:convert';

import 'package:appclient/models/productBillModel.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Itembill extends StatelessWidget {
  const Itembill({
    super.key,
    required this.billItem,
  });
  String parseDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);

    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    String formattedDate =
        '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

    return formattedDate;
  }

  final BiilModel billItem;
  void _showBillDetails(BuildContext context) {
    String date = '${billItem.createdAt}';
    String outputdate = parseDate(date);

    String getPaymentMethodText(int? paymentMethod) {
      if (paymentMethod == 2) {
        return 'Thanh toán VNPAY(không thể hủy đơn hàng, chúng tôi rất tiếc vì sự bất tiện này)';
      } else if (paymentMethod == 1) {
        return 'Thanh toán khi nhận hàng';
      } else {
        return 'N/A';
      }
    }

    Future<void> updateBillStatus(String billId) async {
      final String apiUrl = 'https://adadas.onrender.com/api/bill/$billId';

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Cookie':
            'connect.sid=s%3AXYx_CjlbCsGDQMrBZU-h_tWtB-2NHm1k.2G%2FjjUbfOR8uzYNo%2FD3NfTvFv3WWzHHu4a4f0kjEg%2B8',
      };

      final Map<String, dynamic> data = {
        "status": 9,
      };

      try {
        final http.Response response = await http.put(
          Uri.parse(apiUrl),
          headers: headers,
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          print('Update thành công');
        } else {
          print(
              'Update không thành công. Mã trạng thái: ${response.statusCode}');
          print('Nội dung phản hồi: ${response.body}');
        }
      } catch (error) {
        print('Lỗi khi gọi API: $error');
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        double screenHeight = MediaQuery.of(context).size.height;
        double containerHeight = screenHeight * 0.7;

        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Container(
            height: containerHeight,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            // Thêm nội dung chi tiết bill vào đây
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ngày đặt hàng: $outputdate'),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined),
                                  Text(
                                    '  Địa chỉ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Text('Trần Văn Trọng'),
                              Text('(+84)868132185'),
                              Text(
                                  'Số 48, ngõ 99, Cầu Diễn, Phường Phúc Diễn, Quận Bắc Từ Liêm, Hà Nội'),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.payment_outlined),
                            Text(
                              '  Phương thức thanh toán',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text('${getPaymentMethodText(billItem.payments)}'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: billItem.cartData?.length ?? 0,
                          itemBuilder: (context, cartIndex) {
                            final cartItem = billItem.cartData![cartIndex];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(
                                    0xFF6342E8), // Màu của vòng border
                                radius: 20, // Bán kính của CircleAvatar
                                child: CircleAvatar(
                                  radius:
                                      19, // Bán kính của CircleAvatar bên trong vòng border
                                  backgroundImage: NetworkImage(
                                      cartItem.productData?.image?.first ?? ''),
                                ),
                              ),
                              title: Text(
                                '${cartItem.productData?.name ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6342E8),
                                    fontWeight: FontWeight.bold),
                              ),

                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '${cartItem.productData?.colorName}/${cartItem.productData?.sizeName}'),
                                      Text('x${cartItem.quantity}')
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('đơn giá: '),
                                      Text(
                                          '${NumberFormat.decimalPattern().format(cartItem.productData?.price ?? 0)} đ')
                                    ],
                                  )
                                ],
                              ),
                              // Thêm các nút hoặc hành động khác tại đây
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${billItem?.cartData?.length ?? 0} sản phẩm"),
                            Row(
                              children: [
                                Text('Thành tiền: '),
                                Text(
                                  "${NumberFormat.decimalPattern().format(billItem.totalAmount ?? 0)} đ",
                                  style: TextStyle(
                                      color: Color(0xFF6342E8),
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (billItem.status == 7)
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF6342E8)),
                        ),
                        child: Text(
                          'Đánh giá',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  if (billItem.status == 1 && billItem.payments == 1)
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (billItem.sId != null) {
                            updateBillStatus(billItem.sId!);
                          }
                          
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF6342E8)),
                        ),
                        child: Text(
                          'Hủy đơn hàng',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String getStatusText(int? payment) {
      if (payment == 2) {
        return 'Đã thanh toán';
      } else if (payment == 1) {
        return 'Chưa thanh toán';
      } else {
        return 'N/A';
      }
    }

    return GestureDetector(
      onTap: () => _showBillDetails(context),
      child: Card(
        elevation: 4.0,
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'đơn hàng: ${getStatusText(billItem.payments)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Thêm các trường thông tin khác của hóa đơn tại đây
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: billItem.cartData?.length ?? 0,
              itemBuilder: (context, cartIndex) {
                final cartItem = billItem.cartData![cartIndex];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        const Color(0xFF6342E8), // Màu của vòng border
                    radius: 20, // Bán kính của CircleAvatar
                    child: CircleAvatar(
                      radius:
                          19, // Bán kính của CircleAvatar bên trong vòng border
                      backgroundImage: NetworkImage(
                          cartItem.productData?.image?.first ?? ''),
                    ),
                  ),
                  title: Text(
                    '${cartItem.productData?.name ?? 'N/A'}',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6342E8),
                        fontWeight: FontWeight.bold),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '${cartItem.productData?.colorName}/${cartItem.productData?.sizeName}'),
                          Text('x${cartItem.quantity}')
                        ],
                      ),
                      Row(
                        children: [
                          Text('đơn giá: '),
                          Text(
                              '${NumberFormat.decimalPattern().format(cartItem.productData?.price ?? 0)} đ')
                        ],
                      )
                    ],
                  ),
                  // Thêm các nút hoặc hành động khác tại đây
                );
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${billItem?.cartData?.length ?? 0} sản phẩm"),
                  Row(
                    children: [
                      Text('Thành tiền: '),
                      Text(
                        "${NumberFormat.decimalPattern().format(billItem.totalAmount ?? 0)} đ",
                        style: TextStyle(
                            color: Color(0xFF6342E8),
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
