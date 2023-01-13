// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Product with ChangeNotifier {
  String? id;
  String? categoryId;
  String? name;
  String? image;
  String? description;
  String? price;

  Product({
    this.id,
    this.categoryId,
    this.name,
    this.image,
    this.description,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'].toString(),
      categoryId: json['categoryId'].toString(),
      name: json['productName'],
      image: json['productImage'],
      description: json['productDescription'],
      price: json['productPrice'] as String,
    );
  }

  var productItem = [];
  var favoriteItem = [];

  Future<void> updateStatus(String user, String product) async {
    try {
      const api = 'http://192.168.0.107:4000/api/favorite';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'user': user,
            'product': product,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List> fetchProducts() async {
    final response = await http.get(
        Uri.parse('http://192.168.0.107:4000/api/product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var responseJson = jsonDecode(response.body);
    productItem = responseJson;
    print(productItem);
    return productItem;
  }

  Future<List> fetchFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("uid");
    final response = await http.post(
        Uri.parse('http://192.168.0.107:4000/api/favorite/get'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: json.encode({
          'user': user,
        }));

    var responseJson = jsonDecode(response.body);
    favoriteItem = responseJson;
    print(favoriteItem);
    return favoriteItem;
  }
}
