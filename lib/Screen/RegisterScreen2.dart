// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:appclient/Widgets/getLocationButtonn.dart';
import 'package:appclient/Widgets/uilt.dart';
import 'package:appclient/models/apiRes.dart';
import 'package:appclient/services/baseApi.dart';
import 'package:appclient/services/firebaseAuthService.dart';
import 'package:appclient/services/firebaseMessagingService.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen2 extends StatefulWidget {
  const RegisterScreen2({Key? key, required this.title}) : super(key: key);
  final String title;
  static const String nameRegiterScree2 = "/regiter2";

  @override
  State<RegisterScreen2> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen2> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirebaseMessagingService _messagingService = FirebaseMessagingService();
  final FirebaseAuthService authService = FirebaseAuthService();
  final TextEditingController _fullnameCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _specificAddress = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _rePasswordCtrl = TextEditingController();
  File? _image;
  String latitude = 'Loading...';
  String longitude = 'Loading...';
  String cityname = "";
  var image;
  bool passwordChange = false;

  Future<void> _callAddAddress (BuildContext context , String idUser) async {
    final response = await http.post(
      Uri.parse("$BASE_API/api/address"),
      headers: <String , String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String , String> {
        'idUser' : idUser,
        'address' : _addressCtrl.text.trim(),
        'specificAddres' : _specificAddress.text.trim()
      })
    );

    if(response.statusCode == 200){
      Map<String , dynamic> apiRes = jsonDecode(response.body);
      ApiRes res = ApiRes.fromJson(apiRes);

      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }
    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }

  Future<void> _callRegister(BuildContext context , String phone , String fullname , String email , String password) async{
    String deviceId = await _authService.getDeviceId(context);
    String token = await _messagingService.getToken();

    final request = http.MultipartRequest('POST', Uri.parse("$BASE_API/api/users"));

    if(image != null){
      final File file = File(image!.path);
      request.files.add(
          http.MultipartFile.fromBytes('image', file.readAsBytesSync() , filename: image!.name)
      );
    }
    request.fields['Phone'] = phone;
    request.fields['Fullname'] = fullname;
    request.fields['Email'] = email;
    request.fields['Password'] = password;
    request.fields['Token'] = token;
    request.fields['DeviceId'] = deviceId;

    final response = await request.send();

    if(response.statusCode == 200){
      final res = ApiRes.fromJson(jsonDecode(await response.stream.bytesToString()));
      if(res.err!){
        showSnackBarErr(context, res.msg!);
      }else{
        await _callAddAddress(context, res.idUser!);
        showSnackBar(context, res.msg!);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("idUser", res.idUser.toString());
        await prefs.setString("role", res.role.toString());
        await prefs.setBool("isLogin", true);

        await Navigator.pushReplacementNamed(context,"/");
      }
    }else{
      showSnackBarErr(context, "Lỗi server : code ${response.statusCode}");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    
    if(image != null){
      setState(() {
        _image = File(image!.path);
      });
    }
  }

    Future<void> _getLocation() async {
    await _determinePosition();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        _addressCtrl.text = "lati : $latitude , long : $longitude";
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
        setState(() {
          cityname = city ?? 'Not Found';
        });
        print(cityname);
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

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 304,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/images/background.png'),
                    fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 48,
                      width: 80,
                      height: 128,
                      child: FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(image: AssetImage(
                                    'lib/images/light-2.png')
                            )
                          ),
                        )),
                    ),
                    Positioned(
                      right: 40,
                      top: 16,
                      width: 80,
                      height: 132,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('lib/images/clock.png'))),
                          )),
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      child: Container(
                          margin: const EdgeInsets.only(top:16),
                          child: const Center(
                            child: Text(
                              "Thông tin của bạn",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    Container(
                      margin: const EdgeInsets.only(top: 184),
                      child: Center(
                        child: InkWell(
                            onTap: _pickImage,
                            child: _image == null
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[300],
                                child: const Icon(Icons.add_a_photo, size: 60, color: Colors.grey),
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.file(_image!, width: 120, height: 120, fit: BoxFit.cover),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: <Widget>[
                    FadeInUp(
                        duration: const Duration(milliseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              controller: _fullnameCtrl,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "Họ và tên",
                                hintText: "Fullname",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10)),
                                prefixIcon: const Icon(Icons.person_outline)),
                            ),
                            const SizedBox(height: 16),
                            btnGetLocation(addressCtrl: _addressCtrl , getLocation: _getLocation),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _specificAddress,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Địa chỉ cụ thể",
                                  hintText: "Số nhà , số Đường , Xã/Phường",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.map_outlined)),
                            ),
                            const SizedBox(height: 16),
                            const Text("Đăng nhập bằng Email và mật khẩu" , style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const Text("(Có thể bỏ qua)" , style: TextStyle(
                                fontSize: 16,
                            ),
                            ),
                            TextFormField(
                              controller: _emailCtrl,
                              onChanged: (text) {
                                if(text.isNotEmpty){
                                  setState(() {
                                    passwordChange = true;
                                  });
                                }else{
                                  setState(() {
                                    passwordChange = false;
                                  });
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  hintText: "Email",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.email_outlined)),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordCtrl,
                              enabled: passwordChange,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  labelText: "Mật khẩu",
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.lock_outline)),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _rePasswordCtrl,
                              enabled: passwordChange,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                  labelText: "Nhập lại mật khẩu",
                                  hintText: "RePassword",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  prefixIcon: const Icon(Icons.lock_outline)),
                            ),
                          ],
                        )),
                    const SizedBox(height: 48),
                    FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      child: CustomButton(text: "Lưu", onPressed: () async {
                          _clickSave(context , phone);
                        })
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _clickSave (BuildContext context , String phone){
    String fullname = _fullnameCtrl.text.trim();
    String address = _addressCtrl.text.trim();
    String email = _emailCtrl.text.trim();
    String password = _passwordCtrl.text.trim();
    String rePassword = _rePasswordCtrl.text.trim();
    String specificAddress = _specificAddress.text.trim();

    if(fullname.isEmpty || fullname == ""){
      showSnackBarErr(context, "Vui lòng nhập họ và tên");
    }else if(address.isEmpty || address == ""){
      showSnackBarErr(context, "Vui lòng nhập địa chỉ");
    }else if(specificAddress.isEmpty || specificAddress == ""){
      showSnackBarErr(context, "Vui lòng nhập địa chỉ cụ thể");
    }else if(fullname.length >= 22){
      showSnackBarErr(context, "Họ và tên không dài hơn 22 ký tự");
    } else{
      if(phone.startsWith("+84")){
        phone = phone.substring(3);
      }
      phone = "0$phone";

      if(email.isNotEmpty || email != ""){
        if(!EmailValidator.validate(email)){
          showSnackBarErr(context, "Email không đúng định dạng");
        } else if(password.isEmpty || password == ""){
          showSnackBarErr(context, "Vui lòng nhập mật khẩu");
        }else if(rePassword.isEmpty || rePassword == ""){
          showSnackBarErr(context, "Vui lòng nhập lại mật khẩu");
        }else if(password != rePassword){
          showSnackBarErr(context, "Nhập lại mật khẩu không chính xác");
        }else if(password.length < 8){
          showSnackBarErr(context, "Mật khẩu phải ít nhất 8 ký tự");
        }else{
          _callRegister(context ,phone , fullname , email , password);
        }
      }else{
        _callRegister(context ,phone , fullname , "" , "");
      }
    }

  }
}
