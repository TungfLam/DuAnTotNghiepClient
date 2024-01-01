// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/Location_Model.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<StatefulWidget> createState() => LocationPage();
}
String idUsr = '';
class LocationPage extends State<LocationScreen> {
  List<LocationModel> list = [];
  var select = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
    select = 0;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? idUser = prefs.getString("idUser");
    final String? addressuser = prefs.getString('address');
    idUsr = idUser ?? '';

    try {
      var response = await http.get(Uri.parse(
          '$BASE_API/api/address/$idUser'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        for (int i = 0; i < responseData.length; i++) {
          LocationModel locationModel = LocationModel(
            id : responseData[i]['_id'],
            address: responseData[i]['address'],
            specific_address: responseData[i]['specific_addres'],
          );

          if(addressuser != null){
            if(addressuser == locationModel.id){
              select = i;
              print(addressuser);
              print('==$i');
            }
          }
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
          'Địa chỉ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
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
            const SizedBox(
              height: 20,
            ),
            Text('Số lượng địa chỉ ${list.length}/3')
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 72,
        color: Colors.white,
        child: CustomButton(text: "Thêm địa chỉ", onPressed: (){
          if(list.length >= 3){
            showDialogUilt(context, "Thông báo", "Chỉ được tạo tối đã 3 địa chỉ", (){});
          }else{

          }
        })
      ),
    );
  }
}

Widget itemLocation(BuildContext context, LocationModel location,int index,int select, VoidCallback callback) {
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
    onTap: () {
      callback();
      setAddress(context , idUsr , location.id.toString());
    },
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8 , bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(245, 245, 245, 255),
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
          Expanded(
            flex: 1,
            child: Icon(
              Icons.location_on_sharp,
              color: index == select ? Colors.redAccent : Colors.grey,
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Text(
                    lastLocation ?? '',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(
                        firstLocation ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Future<void> setAddress(BuildContext context , String idUser , String idAddress) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse("$BASE_API/api/setaddress"),
    headers: <String , String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String , String>{
      'idUser' : idUser,
      'idAddress' : idAddress
    })
  );

  if(response.statusCode == 200){
    ApiRes res = ApiRes.fromJson(jsonDecode(response.body));

    if(res.err!){
      showSnackBarErr(context, res.msg!);
    }else{
      await prefs.setString("address", idAddress);
      showSnackBar(context, res.msg!);
    }
  }else{
    showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
  }
}
