// ignore_for_file: avoid_print, use_rethrow_when_possible

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Shipping with ChangeNotifier {
  String? address;
  String? street;
  String? building;

  Shipping({
    this.address,
    this.street,
    this.building,
  });

  Future<void> updateShippingAddress(
    String address,
    String street,
    String building,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('uid');
    try {
      const api = 'http://192.168.0.107:4000/api/shipping';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'address': address,
            'street': street,
            'building': building,
            'user': user,
          }));
      final responseData = json.decode(response.body);
      prefs.setString("address", responseData['Address']);
      prefs.setString("street", responseData['Street']);
      prefs.setString("building", responseData['Building']);
      print(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}

Future<void> getShipping() async {
  final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('uid');
    try {
      const api = 'http://192.168.0.107:4000/api/shipping/get';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'user': user,
          }));
      final responseData = json.decode(response.body);
      prefs.setString("address", responseData['Address']);
      prefs.setString("street", responseData['Street']);
      prefs.setString("building", responseData['Building']);
      print(responseData);
    } catch (error) {
      print(error);
      throw error;
    }
}
