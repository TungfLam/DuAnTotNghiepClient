import 'package:appclient/Screen/PayScreen.dart';
import 'package:appclient/models/AddressModel.dart';
import 'package:appclient/models/ProfileModel.dart';
import 'package:appclient/models/productBillModel.dart';
import 'package:appclient/models/voucherModel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appclient/models/productCartModel.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCart extends StatefulWidget {
  const MyCart({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<ListCart> products = [];

  String selectedPaymentMethod = '';
  List<String> paymentMethods = [
    'Thanh toán khi nhận hàng',
    'Thanh toán VNPAY'
  ];
  bool isVnPaySelected = false;
  List<bool> selectedProducts = [];
  int totalAmount = 0;
  late String userid;
  Listdiscount? selectedVoucher;
  List<Listdiscount> vouchers = [];
  int discountAmount = 0;
  int quantityselect = 0;
  int quantitysave = 0;
  String dc = '';
  String dcct = '';
  ObjUser? profile;

  String fullname = '';
  String ava = '';
  String email = '';
  String sdt = '';
  String idaddress = '';
  ObjAddress? address;
  // late ListCart product;
  void calculateDiscountAmount() {
    discountAmount = 0;

    if (selectedVoucher != null) {
      discountAmount = selectedVoucher!.price ?? 0;
    }
  }

  Future<void> fetchProfile() async {
    // Get user ID from SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? idUser = prefs.getString("idUser");

    // Check if the user is logged in
    if (idUser != null) {
      try {
        final response = await http.get(
          Uri.parse('$BASE_API/api/userproflie/$idUser'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (responseData.containsKey('objUser')) {
            final Map<String, dynamic> objUserData = responseData['objUser'];

            // Update the assignment to a single instance
            profile = ObjUser.fromJson(objUserData);

            // Now you can access the profile data using profile?.objUser
            print('API Response Data: ${response.body}');
            print('Username: ${profile?.username}');
            print('Email: ${profile?.email}');
            print('fullname: ${profile?.fullName}');
            print('sdt: ${profile?.phoneNumber}');
            print('idaddress: ${profile?.address}');
            setState(() {
              fullname = profile?.fullName ?? '';
              ava = profile?.avata ?? '';
              email = profile?.email ?? '';
              sdt = profile?.phoneNumber ?? '';
              idaddress = profile?.address ?? '';
            });
            fetchAddresses(profile?.address ?? '');
            // Add other properties as needed
          } else {
            print('Key objUser not found in JSON response');
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error during API call: $e');
      }
    } else {
      // Redirect to the login page if the user is not logged in
      Navigator.pushNamed(context, '/login');
    }
  }

  Future<void> fetchAddresses(String addressid) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_API/api/get-address/$addressid'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('objAddress')) {
          final Map<String, dynamic> objAddressData =
              responseData['objAddress'];
          address = ObjAddress.fromJson(objAddressData);
          print('địa chỉ là: ${address?.specificAddres}');
          setState(() {
            dc = address?.specificAddres ?? '';
            dcct = address?.address ?? '';
          });
        } else {
          print('Key objAddress not found in JSON response');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during API call: $e');
    }
  }

  Future<void> fetchProducts() async {
    //lấy id user
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isLogin = prefs.getBool("isLogin");
    final String? idUser = prefs.getString("idUser");
    final String? address = prefs.getString("address_city");
    final String? addressdt = prefs.getString("specific_addres");

    if (isLogin != null) {
      if (isLogin == true) {
        print("người dùng đã login");
        setState(() {
          // dc=address!;
          // dcct=addressdt!;
        });
      } else if (isLogin == false) {
        Navigator.pushNamed(context, '/login');
      }
    } else {
      Navigator.pushNamed(context, '/login');
    }

    if (idUser != null) {
      print("user id là: $idUser");
      setState(() {
        userid = idUser;
      });

      try {
        // final response = await http.get(
        //   Uri.parse('$BASE_API/api/getListCart/6524318746e12608b3558d74'),);

        final response = await http.get(
          Uri.parse('$BASE_API/api/getListCart/$idUser'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          // In ra dữ liệu JSON để kiểm tra cấu trúc
          print('JSON Data: $responseData');

          if (responseData.containsKey('listCart')) {
            final dynamic listCartData = responseData['listCart'];

            if (listCartData is List) {
              setState(() {
                products = listCartData
                    .map((item) => ListCart.fromJson(item))
                    .toList();
                print(products.length);
                selectedProducts =
                    List.generate(products.length, (index) => false);
              });
            } else if (listCartData is Map<String, dynamic>) {
              // Xử lý trường hợp listCart là Map, có thể là một sản phẩm duy nhất
              setState(() {
                products = [ListCart.fromJson(listCartData)];
                print(products.length);
              });
            } else {
              print('Invalid data format for listCart');
            }
          } else {
            print('Key listCart not found in JSON response');
          }
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        print('Error during API call: $e');
      }
    }
    //
  }

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

  Future<void> updateCartApiCall(String cartId, int quantity) async {
    // Địa chỉ API và ID cart được truyền vào URL
    final String apiUrl =
        '$BASE_API/api/updateCart/$userid/$cartId';

    // Tạo đối tượng body theo định dạng mà API yêu cầu
    final Map<String, dynamic> requestBody = {
      "quantity": quantity,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Xử lý khi request thành công
        print('Update cart API call successful');
        // Nếu có dữ liệu trả về, bạn có thể xử lý dữ liệu ở đây
      } else {
        // Xử lý khi request không thành công
        print(
            'Update cart API call failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Xử lý khi có lỗi trong quá trình gọi API
      print('Error calling Update cart API: $error');
    }
  }

  Future<void> addBillApiCall(String userid, List<String> cartIds, int amount,
      String idDiscount) async {
    // Tạo đối tượng body theo định dạng mà API yêu cầu
    final Map<String, dynamic> requestBody = {
      "idCart": cartIds,
      "amount": amount,
      "idDiscount": idDiscount,
    };

    try {
      final response = await http.post(
        Uri.parse('$BASE_API/api/addBill/$userid'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Xử lý khi request thành công
        print('Add bill API call successful');
        // Nếu có dữ liệu trả về, bạn có thể xử lý dữ liệu ở đây
      } else {
        // Xử lý khi request không thành công
        print(
            'Add bill API call failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      // Xử lý khi có lỗi trong quá trình gọi API
      print('Error calling Add bill API: $error');
    }
  }

  void _removeItemFromCart(String cartId) async {
    try {
      final response = await http.delete(
        Uri.parse('$BASE_API/api/deleteCart/$cartId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Removed from cart successfully!');
        fetchProducts();
      } else {
        print(
            'Failed to remove from cart. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error removing from cart: $error');
    }
  }

  void updateTotalAmount() {
    totalAmount = 0;
    for (int i = 0; i < products.length; i++) {
      if (selectedProducts[i]) {
        if (products[i].productId?.product?.discount == null) {
          totalAmount += (products[i].productId?.product?.price)! *
              (products[i].quantity ?? 0);
        } else if (products[i].productId?.product?.discount != null) {
          totalAmount += (products[i].productId?.product?.discount)! *
              (products[i].quantity ?? 0);
        }
      }
    }
  }

  void _showProductDetailsModal(BuildContext context, ListCart product) async {
    bool? isBottomSheetClosed = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.productId?.product?.image?.elementAt(0) ??
                                  "",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.productId?.product?.name ?? "Unknown",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Color(0xff6342E8),
                                ),
                              ),
                              Text(
                                  '${product.productId?.sizeId?.name}/${product.productId?.colorId?.name}'),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Số lượng: ${product.quantity}'),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        return Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  decreaseQuantity(product
                                                      .productId!.quantity!);
                                                });
                                                updateCartApiCall(
                                                    product.sId!,
                                                    quantityselect +
                                                        (product.quantity!));
                                              },
                                              icon: const Icon(Icons.remove),
                                            ),
                                            Text(
                                              '${quantityselect + (product.quantity!)}'
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  increaseQuantity(product
                                                      .productId!.quantity!);
                                                });
                                                updateCartApiCall(
                                                    product.sId!,
                                                    quantityselect +
                                                        (product.quantity!));
                                              },
                                              icon: const Icon(Icons.add),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                          quantityselect = 0;
                          fetchProducts();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF6342E8)),
                        ),
                        child:
                            Text('Lưu', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSelectedProductsModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    for (int i = 0; i < products.length; i++)
                      if (selectedProducts[i])
                        _buildProductDetailsWidget(products[i]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined),
                            Text(
                              '  Địa chỉ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text('$fullname'),
                        Text('$sdt'),
                        Row(
                          children: [
                            Expanded(
                              child: Text('$dc,$dcct'),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/location');
                                print('Icon pressed!');
                              },
                              child: Icon(Icons.arrow_right),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Listdiscount>(
                          hint: const Text('Chọn voucher'),
                          value: selectedVoucher,
                          onChanged: (Listdiscount? newSelectedVoucher) {
                            setState(() {
                              selectedVoucher = newSelectedVoucher;
                              calculateDiscountAmount();
                              // Xử lý logic khi voucher được chọn
                            });
                          },
                          items: vouchers.map((Listdiscount voucher) {
                            return DropdownMenuItem<Listdiscount>(
                              value: voucher,
                              child: Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Thêm các widget dựa trên hình ảnh, ví dụ:
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: const ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Image(
                                          image: AssetImage(
                                              'lib/images/voucher.png'),

                                          height: 60,
                                          fit: BoxFit
                                              .cover, // Ảnh sẽ lấp đầy toàn bộ không gian, có thể bị cắt
                                          // Hoặc sử dụng BoxFit.contain để hiển thị toàn bộ ảnh trong không gian, có thể có khoảng trống
                                        ),
                                      ),
                                    ),
                                    Text(voucher.description ?? ''),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          itemHeight: 70,
                          isExpanded:
                              true, // Đặt chiều cao mong muốn cho dropdown
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        hint: const Text('phương thức thanh toán'),
                        value: selectedPaymentMethod.isNotEmpty
                            ? selectedPaymentMethod
                            : null,
                        onChanged: (String? newPaymentMethod) {
                          setState(() {
                            selectedPaymentMethod = newPaymentMethod!;
                            isVnPaySelected =
                                selectedPaymentMethod == 'Thanh toán VNPAY';
                          });
                        },
                        items: paymentMethods.map((String paymentMethod) {
                          return DropdownMenuItem<String>(
                            value: paymentMethod,
                            child: Text(paymentMethod),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tổng tiền: đ${NumberFormat.decimalPattern().format(totalAmount - discountAmount)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // final giagiam = selectedVoucher!.price;

                            if (selectedVoucher != null) {
                              int discountedAmount =
                                  totalAmount - selectedVoucher!.price! ?? 0;

                              print(
                                  'phương thức tt đã chọn: $selectedPaymentMethod');
                              print('voucher đã chọn: ${selectedVoucher?.sId}');
                              List<String> selectedCartIds =
                                  getSelectedCartIds();
                              print(
                                  'những sản phẩm được chọn: $selectedCartIds');
                              if (isVnPaySelected) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PayScreen(
                                        // productId: product.sId!,
                                        userid: userid,
                                        idcart: selectedCartIds,
                                        title: '',
                                        totalAmount: discountedAmount,
                                        idDiscount: selectedVoucher?.sId ?? ''),
                                  ),
                                );
                                print('userid là: $userid');
                                print('selectedCartIds là: $selectedCartIds');
                                print('totalAmount là: $totalAmount');
                                print(
                                    'Tổng tiền: đ${NumberFormat.decimalPattern().format(totalAmount - discountAmount)}');
                              } else {
                                addBillApiCall(
                                    userid,
                                    selectedCartIds,
                                    discountedAmount,
                                    selectedVoucher?.sId ?? '');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('đặt hàng thành công!'),
                                  ),
                                );
                                Navigator.pushNamed(context, '/bill');
                              }
                            } else {
                              int discountedAmount = totalAmount;

                              print(
                                  'phương thức tt đã chọn: $selectedPaymentMethod');
                              print('voucher đã chọn: ${selectedVoucher?.sId}');
                              List<String> selectedCartIds =
                                  getSelectedCartIds();
                              print(
                                  'những sản phẩm được chọn: $selectedCartIds');
                              if (isVnPaySelected) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PayScreen(
                                        // productId: product.sId!,
                                        userid: userid,
                                        idcart: selectedCartIds,
                                        title: '',
                                        totalAmount: discountedAmount,
                                        idDiscount: selectedVoucher?.sId ?? ''),
                                  ),
                                );
                                print('userid là: $userid');
                                print('selectedCartIds là: $selectedCartIds');
                                print('totalAmount là: $totalAmount');
                                print(
                                    'Tổng tiền: đ${NumberFormat.decimalPattern().format(totalAmount - discountAmount)}');
                              } else {
                                // Xử lý thanh toán khác
                                addBillApiCall(
                                    userid,
                                    selectedCartIds,
                                    discountedAmount,
                                    selectedVoucher?.sId ?? '');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('đặt hàng thành công!'),
                                  ),
                                );
                                Navigator.pushNamed(context, '/bill');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6342E8),
                          ),
                          child: const Text(
                            'Thanh toán',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductDetailsWidget(ListCart product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.productId?.product?.image?.elementAt(0) ?? "",
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productId?.product?.name ?? "Unknown",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: Color(0xff6342E8),
                      ),
                    ),
                    Text(
                        '${product.productId?.sizeId?.name}/${product.productId?.colorId?.name}'),
                    Text('Số lượng: ${product.quantity}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchVouchers();
    fetchProfile();
    selectedProducts = List.generate(products.length, (index) => false);
    yourFunctionToProcessSelectedCarts();
  }

  void increaseQuantity(int maxQuantity) {
    if (quantityselect < maxQuantity - quantitysave) {
      setState(() {
        quantityselect++;
        print(quantityselect);
      });
    }
  }

  void decreaseQuantity(int maxQuantity) {
    if (quantitysave + quantityselect > 1) {
      setState(() {
        quantityselect--;
        print(quantityselect);
      });
    }
  }

  List<String> getSelectedCartIds() {
    List<String> selectedCartIds = [];
    for (int i = 0; i < selectedProducts.length; i++) {
      if (selectedProducts[i]) {
        String idcartselect = "${products[i].sId}";
        selectedCartIds.add(idcartselect ?? '');
      }
    }
    return selectedCartIds;
  }

  void yourFunctionToProcessSelectedCarts() {
    updateTotalAmount();
    calculateDiscountAmount();
    List<String> selectedCartIds = getSelectedCartIds();
    // Tiếp tục xử lý danh sách selectedCartIds theo nhu cầu của bạn
    print('Selected Cart IDs: $selectedCartIds');
    // Gọi API hoặc thực hiện các công việc khác với danh sách đã chọn
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
          'Giỏ hàng',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: const [],
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: 620,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 2,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    if (index < products.length) {
                      final product = products[index];
                      if (product.productId != null &&
                          product.productId!.product != null) {
                        print(product.productId?.quantity);
                        quantitysave = product.quantity!;
                        return GestureDetector(
                          onTap: () {
                            if (index < products.length) {
                              final product = products[index];
                              if (product.productId != null) {
                                _showProductDetailsModal(context, product);
                                print(
                                    'soluongmax: ${product.productId!.quantity!}');
                              }
                            }
                          },
                          child: Card(
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        value: selectedProducts[index],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedProducts[index] = value!;
                                            yourFunctionToProcessSelectedCarts();
                                          });
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 10, 10),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            product.productId?.product?.image
                                                    ?.elementAt(0) ??
                                                "",
                                            height: 200,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 10, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 5,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 40, 0),
                                                child: Text(
                                                  product.productId?.product
                                                          ?.name ??
                                                      "Unknown",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff6342E8)),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Kích cỡ: ${product.productId?.sizeId?.name ?? ''}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Màu sắc: ${product.productId?.colorId?.name ?? ''}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                children: [
                                                  const Text("Số lượng:  "),
                                                  Text(
                                                    //  '${quantityselect + product.quantity!}'
                                                    '${quantitysave}'
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  if (product.productId?.product
                                                          ?.discount ==
                                                      null)
                                                    Text(
                                                      '${NumberFormat.decimalPattern().format(product.productId?.product?.price ?? '')} đ',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  if (product.productId?.product
                                                          ?.discount !=
                                                      null)
                                                    Text(
                                                      '${NumberFormat.decimalPattern().format(product.productId?.product?.discount ?? '')} đ',
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Xác nhận xóa sản phẩm'),
                                            content: const Text(
                                                'Bạn muốn xóa sản phẩm này?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Đóng hộp thoại
                                                  if (product.sId != null) {
                                                    _removeItemFromCart(
                                                        product.sId!);
                                                  } else {
                                                    print(
                                                        'CartId is null for product at index $index');
                                                  }
                                                },
                                                child: const Text('Có'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Đóng hộp thoại
                                                },
                                                child: const Text('Hủy'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        print('productId is null for product at index $index');
                        return const SizedBox
                            .shrink(); // Nếu productId là null, có thể trả về một widget trống hoặc thích hợp khác.
                      }
                    } else {
                      if (mounted) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }
                    return null;
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tổng tiền: ${NumberFormat.decimalPattern().format(totalAmount)} đ',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Xử lý khi nút Mua Hàng được nhấn
                        print(
                            'Tổng tiền: ${NumberFormat.decimalPattern().format(totalAmount)} đ');
                        _showSelectedProductsModal();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6342E8),
                      ),
                      child: const Text(
                        'Mua Hàng',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
