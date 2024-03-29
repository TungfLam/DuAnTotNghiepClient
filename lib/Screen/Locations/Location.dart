// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Screen/Locations/ChangeLocation.dart';
import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/loading.dart';
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

  bool _isLoading = false;

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
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? idUser = prefs.getString("idUser");
    final String? addressuser = prefs.getString('address');
    idUsr = idUser ?? '';

    try {
      var response = await http.get(Uri.parse(
          '$BASE_API/api/address/$idUser'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        list.clear();
        for (int i = 0; i < responseData.length; i++) {
          LocationModel locationModel = LocationModel(
            id : responseData[i]['_id'],
            address: responseData[i]['address'],
            specific_address: responseData[i]['specific_addres'],
          );

          if(addressuser != null){
            if(addressuser == locationModel.id){
              select = i;
            }
          }
          setState(() {
            list.add(locationModel);
          });
        }
      }
    } catch (error) {
      showSnackBarErr(context, "Err : Vui lòng thử lại sau");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách địa chỉ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
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

          _isLoading ? const showLoading() : const SizedBox()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 72,
        color: Colors.white,
        child: CustomButton(text: "Thêm địa chỉ", onPressed: (){
          if(list.length >= 3){
            showDialogUilt(context, "Thông báo", "Chỉ được tạo tối đã 3 địa chỉ", (){});
          }else{
            Navigator.of(context).pushNamed(ChangeLocation.nameChangeLocation , arguments: "").then((result) {
              fetchData();
            });
          }
        })
      ),
    );
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
        padding: const EdgeInsets.symmetric(vertical: 16 , horizontal: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(245, 245, 245, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 4,
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
            ),
            Expanded(
                flex: 1,
                child: InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(ChangeLocation.nameChangeLocation , arguments: location.id.toString()).then((value) {
                        fetchData();
                      });
                    },
                    child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.edit_location_alt_outlined , color: Colors.grey,)
                    )
                )
            )
          ],
        ),
      ),
    );
  }

  Future<void> setAddress(BuildContext context , String idUser , String idAddress) async {
    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;
    });
  }

}


