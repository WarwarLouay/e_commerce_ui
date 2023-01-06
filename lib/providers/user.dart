// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../exception/http_exception.dart';

class User with ChangeNotifier {
  String? id;
  String? fullName;
  String? email;
  String? country;
  String? countryCode;
  String? phone;
  String? password;
  String? _token;

  User({
    this.id,
    this.fullName,
    this.email,
    this.country,
    this.countryCode,
    this.phone,
    this.password,
  });

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token!;
    }
    return null;
  }

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

  Future<void> login(String email, String password) async {
    try {
      const api = 'http://192.168.0.107:4000/api/user/login';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'email': email,
            'password': password,
          }));
      final responseData = json.decode(response.body);
      if (responseData['user']['message'] == 'Incorrect email') {
        throw HttpException('Incorrect email');
      }
      if (responseData['user']['message'] == 'Incorrect password') {
        throw HttpException('Incorrect password');
      }

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("token", responseData['token']);
      prefs.setString("uid", responseData['user']['_id']);

      const api2 = 'http://192.168.0.107:4000/api/shipping/get';
      final Uri url2 = Uri.parse(api2);
      final response2 = await http.post(url2,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'user': responseData['user']['_id'],
          }));
      final responseData2 = json.decode(response2.body);
      prefs.setString("shipping", responseData2['_id']);
      prefs.setString("address", responseData2['Address']);
      prefs.setString("street", responseData2['Street']);
      prefs.setString("building", responseData2['Building']);

      print(responseData);
      print(responseData2);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    print(_token);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
