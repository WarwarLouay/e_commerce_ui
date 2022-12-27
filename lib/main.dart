// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_ui/pages/cart_page.dart';
import 'package:e_commerce_ui/pages/home_page.dart';
import 'package:e_commerce_ui/pages/item_page.dart';
import 'package:e_commerce_ui/providers/cart.dart';
import 'package:e_commerce_ui/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Product(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        routes: {
          '/': (context) => HomePage(),
          'cartPage': (context) => CartPage(),
          'itemPage': (context) => ItemPage(),
        },
      ),
    );
  }
}
