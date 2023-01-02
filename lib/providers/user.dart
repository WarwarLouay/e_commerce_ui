// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../exception/http_exception.dart';

class User with ChangeNotifier {
  String? id;
  String? fullName;
  String? email;
  String? country;
  String? countryCode;
  String? phone;
  String? password;

  User({
    this.id,
    this.fullName,
    this.email,
    this.country,
    this.countryCode,
    this.phone,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'].toString(),
      fullName: json['fullName'],
      email: json['email'],
      country: json['country'],
      countryCode: json['countryCode'],
      phone: json['phone'],
    );
  }

  Future<void> createAccount(
    String fullName,
    String email,
    String country,
    String countryCode,
    String phone,
    String password,
  ) async {
    try {
      const api = 'http://192.168.0.107:4000/api/user';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'fullName': fullName,
            'email': email,
            'country': country,
            'countryCode': countryCode,
            'phone': phone,
            'password': password,
          }));
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'Email already exist') {
        throw HttpException('exist');
      }
      print(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
