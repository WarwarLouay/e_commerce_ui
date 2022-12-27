// ignore_for_file: avoid_print, use_rethrow_when_possible, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Cart with ChangeNotifier {
  String? id;
  String? productId;
  String? name;
  String? image;
  double? price;
  int? qty;

  Cart({
    this.id,
    this.productId,
    this.name,
    this.image,
    this.price,
    this.qty,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'].toString(),
      productId: json['productId'].toString(),
      name: json['productId']['productName'],
      image: json['productId']['productImage'],
      price: json['productId']['productPrice'] as double,
      qty: json['qty'] as int,
    );
  }

  var cartItem = [];

  int get itemCount {
    return cartItem.length;
  }

  double get totalAmount {
    var total = 0.0;
      cartItem.forEach((element) {
        total += element['qty'] * element['productId']['productPrice'];
    });
    return total;
  }

  Future<void> addToCart(
    String productId,
    int qty,
  ) async {
    try {
      const api = 'http://192.168.0.107:4000/api/cart';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'productId': productId,
            'qty': qty,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      cartItem.add(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> delete(String id) async {
    try {
      const api = 'http://192.168.0.107:4000/api/cart/delete';
      final Uri url = Uri.parse(api);
      final response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: json.encode({
            'id': id,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      final existingProductIndex =
          cartItem.indexWhere((prod) => prod['_id'] == id);
      var existingProduct = cartItem[existingProductIndex];
      cartItem.removeAt(existingProductIndex);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<Cart>> fetchCart() async {
    final response = await http.get(
        Uri.parse('http://192.168.0.107:4000/api/cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var responseJson = jsonDecode(response.body);
    cartItem = responseJson;
    print(cartItem);
    return (responseJson as List).map((p) => Cart.fromJson(p)).toList();
  }
}
