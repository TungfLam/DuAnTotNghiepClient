import 'dart:convert';
import 'package:appclient/Screen/DetaildcProduct.dart';

import 'package:appclient/models/slideShowMOdel.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({Key? key}) : super(key: key);

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  List<ListBanners> banners = [];

  @override
  void initState() {
    super.initState();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    const apiUrl = '$BASE_API/api/banner';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final slideshowData = slideshow.fromJson(jsonDecode(response.body));

        setState(() {
          banners = slideshowData.listBanners ?? [];
        });
      } else {
        print('API Request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during API call: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: banners.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          banner.imageBanner ?? '',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.description ?? 'No description',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            // Hiển thị danh sách sản phẩm
                            if (banner.productId != null)
                              buildProductGrid(banner.productId!),
                          ],
                        ),
                      ),
                      // Thêm các trường thông tin khác của banner tại đây
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget buildProductGrid(List<ProductIdDC> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final productdc = products[index];
        return InkWell(
          onTap: () {
            // Handle the tap event here, for example, navigate to a new screen
            // or show a dialog with more details about the product.
            print('Product tapped: ${productdc.name}');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailDcProduct(
                  title: 'Chi tiết sản phẩm',
                  productdc:
                      productdc, // Truyền đối tượng sản phẩm đã được chọn
                ),
              ),
            );
          },
          child: Card(
            margin: EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    productdc.image?.isNotEmpty == true
                        ? productdc.image![0]
                        : 'placeholder_image_url',
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productdc.name ?? 'No name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${NumberFormat.decimalPattern().format(productdc.price ?? 0)} đ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${NumberFormat.decimalPattern().format(productdc.discount ?? 0)} đ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff9975ff),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
