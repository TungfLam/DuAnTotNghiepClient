import 'dart:convert';

import 'package:appclient/models/Location_Model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<StatefulWidget> createState() => LocationPage();
}

class LocationPage extends State<LocationScreen> {
  List<LocationModel> list = [];
  var select = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse(
          'https://adadas.onrender.com/api/address/6524318746e12608b3558d74'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        for (int i = 0; i < responseData.length; i++) {
          LocationModel locationModel = LocationModel(
              address: responseData[i]['address'],
              specific_address: responseData[i]['specific_addres']);
          setState(() {
            list.add(locationModel);
          });
        }
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Location',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            // Handle the back button press here, such as navigating back
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.5,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var notifi = list[index];
                return itemLocation(context, notifi, index, select, () {
                  setState(() {
                    select = index;
                  });
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text('Số lượng địa chỉ ${list.length}/3')
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6342E8)),
              onPressed: () {},
              child: const Text(
                'THÊM ĐỊA CHỈ',
                style: TextStyle(color: Colors.white),
              ))),
    );
  }
}

Widget itemLocation(BuildContext context, LocationModel location, int index,
    int select, VoidCallback callback) {
  String? firstLocation;
  String? lastLocation;
  String loca = '${location.specific_address}, ${location.address}';
  List<String> list = loca.toString().split(',');
  if (list.length >= 3) {
    firstLocation =
        list.sublist(0, list.length - 3).join(',').replaceAll(',', ' ').trim();
    lastLocation = list.sublist(list.length - 3, list.length).join(',').trim();
  }
  return InkWell(
    onTap: () => {callback()},
    child: Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? const Color.fromARGB(245, 245, 245, 255)
            : const Color.fromARGB(245, 245, 245, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.location_on_sharp,
                color: index == select ? Colors.redAccent : Colors.grey,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Text(
                  lastLocation ?? '',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      firstLocation ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
              )
            ],
          )
        ],
      ),
    ),
  );
}
