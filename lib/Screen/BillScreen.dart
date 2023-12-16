import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appclient/models/productBillModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({Key? key}) : super(key: key);

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  List<Data>? danhSachDonHang = [];

  @override
  void initState() {
    super.initState();
    // Gọi hàm để lấy dữ liệu từ API khi widget được khởi tạo
    layDuLieuDonHang();
  }

  // Hàm để gọi API và xử lý dữ liệu
  void layDuLieuDonHang() async {
    // const url = '$BASE_API/api/bill/6524318746e12608b3558d74';
    const url = 'https://adadas.onrender.com/api/bill/6524318746e12608b3558d74';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    if (isLogin != null) {
      print("người dùng đã login");
    } else {
      Navigator.pushNamed(context, '/login');
    }

    if (idUser != null) {
      print("user id là: $idUser");
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> duLieuPhanHoi = json.decode(response.body);

          // Kiểm tra trạng thái và xử lý dữ liệu nếu trạng thái là 1
          if (duLieuPhanHoi['status'] == 1) {
            final danhSachDuLieu = duLieuPhanHoi['data'] as List<dynamic>;

            // Chuyển đổi dữ liệu từ JSON thành danh sách các đối tượng Data
            danhSachDonHang =
                danhSachDuLieu.map((duLieu) => Data.fromJson(duLieu)).toList();

            // Force widget rebuild để hiển thị dữ liệu mới
            setState(() {});
          } else {
            // Xử lý trạng thái khác 1 nếu cần thiết
            print('Trạng thái không phải là 1');
          }
        } else {
          // Xử lý lỗi nếu có
          print('Lỗi: ${response.statusCode}');
        }
      } catch (e) {
        // Xử lý lỗi nếu có
        print('Lỗi: $e');
      }
    }
  }

  // Hàm tùy chỉnh để hiển thị mỗi mục trong ListView
  Widget xayDungMucDonHang(BuildContext context, int index) {
    final donHangHienTai = danhSachDonHang![index];

    // Tùy chỉnh giao diện của từng mục trong ListView ở đây
    return GestureDetector(
      onTap: () {
        // Thêm chức năng khi một mục được chạm vào
        print(
            'Mục được chạm vào: ${donHangHienTai?.cartId?.productId?.productId?.name}');
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Địa chỉ: ${donHangHienTai?.userId?.address}'),
              Text('Trạng thái đơn hàng: ${donHangHienTai?.cartId!.status}'),
              Text('Ngày đặt hàng: ${donHangHienTai?.date}'),
              Text('Phương thức thanh toán: ${donHangHienTai?.payments}'),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Image.network(
                        donHangHienTai?.cartId?.productId?.productId?.image
                                ?.elementAt(0) ??
                            '...',
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          donHangHienTai?.cartId?.productId?.productId?.name ??
                              'Không xác định',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff6342E8)),
                        ),
                        Row(
                          children: [
                            Text(
                                "Kích cỡ: ${donHangHienTai?.cartId?.productId?.sizeId?.name ?? 'Không xác định'}"),
                            Text(
                                " / Màu sắc: ${donHangHienTai?.cartId?.productId?.colorId?.name ?? 'Không xác định'}"),
                          ],
                        ),
                        Text(
                          '\đ${donHangHienTai?.cartId?.productId?.productId?.price ?? 'Không xác định'}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Text('Số lượng: ${donHangHienTai?.cartId?.quantity}'),
              Text(
                  "Thành tiền: \đ${(donHangHienTai?.cartId?.quantity ?? 0) * (donHangHienTai?.cartId?.productId?.productId?.price ?? 0)}"),
              ElevatedButton(onPressed: () {}, child: Text('Hủy đơn hàng')),
              // Thêm các thông tin khác của đơn hàng tại đây
            ],
          ),
        ),
      ),
    );
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
          'Đơn hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      // Hiển thị danh sách đơn hàng trong ListView
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ListView.builder(
          itemCount: danhSachDonHang?.length ?? 0,
          itemBuilder: (context, index) {
            final donHangHienTai = danhSachDonHang?[index];
            return xayDungMucDonHang(context, index);
          },
        ),
      ),
    );
  }
}
