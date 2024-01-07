// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/getLocationButtonn.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLocation extends StatefulWidget {
  const ChangeLocation({super.key});
  static String nameChangeLocation = "/ChangeLoaction";
  @override
  State<StatefulWidget> createState() {
    return ChangeLocationPage();
  }
}

class ChangeLocationPage extends State<ChangeLocation> {
  final String baseApiProvinces = "https://provinces.open-api.vn";
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _specificAddress = TextEditingController();
  final TextEditingController _tinhCtrl = TextEditingController();
  final TextEditingController _huyenCtrl = TextEditingController();
  final TextEditingController _xaCtrl = TextEditingController();

  List provincesP = [{"name" : "Chọn thành phố / Tỉnh" , 'code' : 0}];
  List provincesD = [{"name" : "Chọn quận" , 'code' : 0}];
  List provincesW = [{"name" : "Chọn phường" , 'code' : 0}];

  String valueProvinceP = "";
  String valueProvinceD = "";
  String valueProvinceW = "";

  String latitude = 'Loading...';
  String longitude = 'Loading...';
  String cityname = "";

  bool isAdd = false;
  dynamic objAddress ;
  String idAddress = "";

  Future<void> getProvincesP () async {
    final dio = Dio();
    final responseP = await dio.get("$baseApiProvinces/api/p");

    if(responseP.statusCode == 200){
      provincesP.addAll(responseP.data);
      setState(() {});
    }else{
      showSnackBarErr(context, "Lỗi server code : ${responseP.statusCode}");
    }
  }

  Future<void> getProvincesD (int provinceCode) async {
    final dio = Dio();
    final responseD = await dio.get("$baseApiProvinces/api/p/$provinceCode/?depth=2");

    if(responseD.statusCode == 200){
      provincesD = responseD.data['districts'];
      setState(() {});
    }else{
      showSnackBarErr(context, "Lỗi server code : ${responseD.statusCode}");
    }
  }

  Future<void> getProvincesW (int districtCode) async {
    final dio = Dio();
    final responseW = await dio.get("$baseApiProvinces/api/d/$districtCode/?depth=2");

    if(responseW.statusCode == 200){
      provincesW = responseW.data['wards'];
      setState(() {});
    }else{
      showSnackBarErr(context, "Lỗi server code : ${responseW.statusCode}");
    }
  }

  Future<void> _getLocation() async {
    _addressCtrl.text = "Đang tìm ...";
    await _determinePosition();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });
      await _getCityName();
      setState(() {
        _addressCtrl.text = cityname;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCityName() async {

    const apiKey = 'fYfBOiPvOSBAI4T2A2JyFPdga7OPBzJhTYzz93V7';
    final apiUrl = 'https://rsapi.goong.io/Geocode?latlng=$latitude,$longitude&api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final data = await json.decode(response.body);
        final city = await data['results'][0]['address'];
        cityname = city ?? 'Not Found';
        List<String> citynames = cityname.split(',');

        if(citynames.length >= 3){
          _xaCtrl.text = citynames[citynames.length - 3];
          _huyenCtrl.text = citynames[citynames.length - 2];
          _tinhCtrl.text = citynames[citynames.length - 1];
        }
        setState(() {});
      } else {
        showSnackBarErr(context, "Không thể định vị được bạn");
        throw Exception('Failed to load city name');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await showDialogUilt(context, "Thông báo", "Vui lòng cấp quyền truy cập vị trí để sử dụng tính năng này", (){
        openAppSettings();
      });
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _addLoaction(String address , String specificaddes) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String idUser = prefs.getString("idUser") ?? "";

    if(idUser == ""){
      Navigator.pop(context);
      showSnackBarErr(context, "Tài khoản không xác định");
      return;
    }

    final response = await http.post(
      Uri.parse("$BASE_API/api/address"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String , String>{
        'idUser' : idUser,
        'address' : address,
        'specificAddres' : specificaddes
      })
    );

    if(response.statusCode == 200){
      ApiRes res = ApiRes.fromJson(await jsonDecode(response.body));

      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }else{
        showSnackBar(context, res.msg!);
        Navigator.pop(context);
        setState(() {});
      }

    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }

  Future<void> _getAdderss(String id) async {
    final response = await http.get(
      Uri.parse("$BASE_API/api/get-address/$id"),
    );

    if(response.statusCode == 200){
      objAddress = await jsonDecode(response.body);

      if(objAddress['err']){
        showSnackBarErr(context, "Lỗi vui lòng thử lại sau");
        Navigator.pop(context);
      }else{
        List<String> citynames = objAddress['objAddress']['address'].split(',');

        if(citynames.length >= 3){
          _xaCtrl.text = citynames[citynames.length - 3];
          _huyenCtrl.text = citynames[citynames.length - 2];
          _tinhCtrl.text = citynames[citynames.length - 1];
        }
        _addressCtrl.text = objAddress['objAddress']['address'];
        _specificAddress.text = objAddress['objAddress']['specific_addres'];
      }
    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }

  Future<void> _updateAddress(String id, String address, String specificAddress) async {
    final response = await http.put(
      Uri.parse("$BASE_API/api/address/$id"),
      headers: <String , String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String , String>{
        'address' : address,
        'specificAddress' : specificAddress
      })
    );

    if(response.statusCode == 200){
      ApiRes res = ApiRes.fromJson(await jsonDecode(response.body));

      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }else{
        showSnackBar(context, res.msg!);
        Navigator.pop(context);
      }
    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }
  
  Future<void> _deleteAddress(String id) async {
    final response = await http.delete(
      Uri.parse("$BASE_API/api/address/$id")
    );

    if(response.statusCode == 200){
      ApiRes res = ApiRes.fromJson(await jsonDecode(response.body));

      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }else{
        showSnackBar(context, res.msg!);
        Navigator.pop(context);
      }

    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();

    getProvincesP();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final idAddr = ModalRoute.of(context)!.settings.arguments.toString();
    if(idAddr == ""){
      isAdd = true;
    }else{
      isAdd = false;
      idAddress = idAddr;
      _getAdderss(idAddr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Địa chỉ"),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 32,
                      initialSelection: '0',
                      controller: _tinhCtrl,
                      onSelected: (String? value){
                        try{
                          if(int.parse(value!) == 0) return;
                          getProvincesD(int.parse(value));
                          for(var item in provincesP){
                            if(item['code'] == int.parse(value)){
                              String nameP = item['name'];
                              if(nameP.toString().startsWith("Tỉnh")){
                                nameP = nameP.substring(5);
                              }else if(nameP.startsWith("Thành phố")){
                                nameP = nameP.substring(10);
                              }
                              valueProvinceP = nameP;
                              setState(() {});
                            }
                          }

                          _huyenCtrl.text = "Chọn quận";
                          _xaCtrl.text = "Chọn phường";
                        }catch(e){
                          print("eer : $e");
                        }
                      },
                      dropdownMenuEntries: provincesP.map<DropdownMenuEntry<String>>((value) {
                        return DropdownMenuEntry(
                          value: value['code'].toString(),
                          label: value['name']
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 32,
                      initialSelection: '0',
                      controller: _huyenCtrl,
                      onSelected: (String? value){
                        try{
                          if(int.parse(value!) == 0) return;
                          for(var item in provincesD){
                            if(item['code'] == int.parse(value)){
                              String nameD = item['name'];
                              if(nameD.startsWith("Huyện")){
                                nameD = nameD.substring(6);
                              }else if(nameD.startsWith("Quận")){
                                nameD = nameD.substring(5);
                              }
                              if(nameD == "Chọn quận"){
                                return;
                              }
                              valueProvinceD = nameD;
                              getProvincesW(int.parse(value));
                              setState(() {});
                            }
                          }
                          _xaCtrl.text = "Chọn phường";
                        }catch(e){
                          print("eer : $e");
                        }
                      },
                      dropdownMenuEntries: provincesD.map<DropdownMenuEntry<String>>((value) {
                        return DropdownMenuEntry(
                            value: value['code'].toString(),
                            label: value['name']
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: DropdownMenu<String>(
                      width: MediaQuery.of(context).size.width - 32,
                      initialSelection: '0',
                      controller: _xaCtrl,
                      onSelected: (String? value){
                        try{
                          if(int.parse(value!) == 0) return;
                          for(var item in provincesW){
                            if(item['code'] == int.parse(value)){
                              String nameW = item['name'];
                              if(nameW.startsWith("Phường")){
                                nameW = nameW.substring(7);
                              }else if(nameW.startsWith("Xã")){
                                nameW = nameW.substring(3);
                              }else if(nameW.startsWith("Thị trấn")){
                                nameW = nameW.substring(9);
                              }
                              if(nameW == "Chọn phường"){
                                return;
                              }
                              cityname = "$nameW, $valueProvinceD, $valueProvinceP";
                              _addressCtrl.text = cityname;
                              setState(() {});
                            }
                          }
                        }catch(e){
                          print("eer : $e");
                        }

                      },
                      dropdownMenuEntries: provincesW.map<DropdownMenuEntry<String>>((value) {
                        return DropdownMenuEntry(
                            value: value['code'].toString(),
                            label: value['name']
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: btnGetLocation(addressCtrl: _addressCtrl, getLocation: _getLocation)
                  ),
                  const SizedBox(height: 16),

                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: _specificAddress,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Địa chỉ cụ thể",
                          hintText: "Số nhà , số Đường , Xã/Phường",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                          prefixIcon: const Icon(Icons.map_outlined)),
                      ),
                  ),
                  const SizedBox(height: 160),
                ]
              )
            ),
          ),

          isAdd ?
          Positioned(
            bottom: 24,
            right: 16,
            left: 16,
            child: Column(
              children: [
                CustomButton(text: "Thêm địa chỉ", onPressed: clickAdd),
              ],
            ),
          )
          :
          Positioned(
            bottom: 24,
            right: 16,
            left: 16,
            child: Column(
              children: [
                CustomButton(text: "Cập nhật", onPressed: (){
                  clickAdd();
                }),
                const SizedBox(height: 16),
                CustomButtonOutlineRed(text: "Xóa địa chỉ", onPressed: (){
                  showDialogUilt2(context, "Xóa", "Bạn có chắc muốn xóa địa chỉ này", (){
                    _deleteAddress(idAddress);
                  });
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  void clickAdd(){
    String address = _addressCtrl.text;
    String specificAddress = _specificAddress.text.trim();

    if(address.isEmpty){
      showSnackBarErr(context, "Vui lòng nhập địa chỉ");
    }else if(specificAddress.isEmpty){
      showSnackBarErr(context, "Vui lòng nhập địa chỉ cụ thể");
    }else if(specificAddress.length > 200){
      showSnackBarErr(context, "Địa chỉ cụ thể không được quá 60 ký tự");
    } else{
      showDialogUilt2(
        context,
        "Xác nhận thông tin",
        "Địa chỉ : ${_addressCtrl.text}\nĐịa chỉ cụ thể : ${_specificAddress.text.trim()}",
        (){
          isAdd ?
          _addLoaction(address , specificAddress) : _updateAddress(idAddress ,address, specificAddress);
        }
      );
    }

  }
}
