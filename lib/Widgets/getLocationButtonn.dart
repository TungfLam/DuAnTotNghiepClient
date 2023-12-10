// ignore_for_file: camel_case_types

import 'package:appclient/Widgets/buttomCustom.dart';
import 'package:flutter/material.dart';

class btnGetLocation extends StatelessWidget{
  final TextEditingController addressCtrl;
  final Function getLocation;

  const btnGetLocation({super.key , required this.addressCtrl , required this.getLocation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: TextFormField(
              enabled: false,
              controller: addressCtrl,
              keyboardType: TextInputType.text,
              style: const TextStyle(
                color: Colors.black, // or any color you prefer
              ),
              decoration: InputDecoration(
                  labelText: "Địa chỉ",
                  hintText: "Address",
                  labelStyle: const TextStyle(
                    color: Colors.black, // or any color you prefer
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF6C4EE7)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.gps_fixed_outlined),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
              child: CustomButtonGPS(text: "dd", onPressed: (){
                getLocation();
              })
          )
        ],

      ),
    );
  }

}