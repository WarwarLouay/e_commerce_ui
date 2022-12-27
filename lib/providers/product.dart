// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  String? id;
  String? categoryId;
  String? name;
  String? image;
  String? description;
  double? price;

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
      price: json['productPrice'] as double,
    );
  }

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(
      Uri.parse('http://192.168.0.107:4000/api/product'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      });

  var responseJson = jsonDecode(response.body);
  print(responseJson);
  return (responseJson as List).map((p) => Product.fromJson(p)).toList();
}
