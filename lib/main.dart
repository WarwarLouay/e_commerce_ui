// ignore_for_file: prefer_const_constructors

import 'package:e_commerce_ui/pages/cart_page.dart';
import 'package:e_commerce_ui/pages/home_page.dart';
import 'package:e_commerce_ui/pages/item_page.dart';
import 'package:e_commerce_ui/pages/login_page.dart';
import 'package:e_commerce_ui/pages/order_details_page.dart';
import 'package:e_commerce_ui/providers/cart.dart';
import 'package:e_commerce_ui/providers/product.dart';
import 'package:e_commerce_ui/providers/shipping.dart';
import 'package:e_commerce_ui/providers/user.dart';
import 'package:e_commerce_ui/widgets/splash_screen.dart';
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
        ChangeNotifierProvider(
          create: (context) => User(),
        ),
        ChangeNotifierProvider(
          create: (context) => Shipping(),
        ),
      ],
      child: Consumer<User>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
          ),
          home: auth.isAuth
              ? HomePage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoginPage();
                    } else {
                      return LoginPage();
                    }
                  }),
          routes: {
            'cartPage': (context) => CartPage(),
            'itemPage': (context) => ItemPage(),
            'order-details': (context) => OrderDetailsPage(),
          },
        ),
      ),
    );
  }
}
