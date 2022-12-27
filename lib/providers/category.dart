// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

class Category {
  String? id;
  String? name;
  String? image;

  Category({
    this.id,
    this.name,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'].toString(),
      name: json['categoryName'],
      image: json['categoryImage'],
    );
  }
}

Future<List<Category>> fetchCategories() async {
  final response = await http.get(
      Uri.parse('http://192.168.0.107:4000/api/category'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      });

    var responseJson = jsonDecode(response.body);
    print(responseJson);
    return (responseJson as List).map((p) => Category.fromJson(p)).toList();
  
}
