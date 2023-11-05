import 'dart:convert';
import 'package:http/http.dart' as http;

    Future<http.Response> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.45.108:6868/api/products'));
    return response;
  }