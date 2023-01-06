// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_is_empty

import 'package:e_commerce_ui/pages/home_page.dart';
import 'package:e_commerce_ui/pages/shipping_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart.dart';

class CartBottomNavBar extends StatefulWidget {
  const CartBottomNavBar({super.key});

  @override
  State<CartBottomNavBar> createState() => _CartBottomNavBarState();
}

class _CartBottomNavBarState extends State<CartBottomNavBar> {
  String? address;
  String? street;
  String? building;

  void getShippingAddres() async {
    final prefs = await SharedPreferences.getInstance();
    address = prefs.getString("address");
    street = prefs.getString("street");
    building = prefs.getString("building");
  }

  @override
  void initState() {
    super.initState();
    getShippingAddres();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> checkout(Cart cart) async {
      if (cart.cartItem.length <= 0) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Sorry!'),
                  content: Text('Your Cart is empty.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ),
                  ],
                ));
      } else if (address != '' || street != '' || building != '') {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Attention!'),
                  content: Text('Make sure you put the correct address please'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ShippingPage()));
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await Provider.of<Cart>(context, listen: false)
                            .addOrder();

                        return showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('Success!'),
                                  content:
                                      Text('We recieve your order. Thank you.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    HomePage()));
                                      },
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                          color: Color(0xFF4C53A5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ),
                  ],
                ));
      } else {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Sorry!'),
                  content:
                      Text('You need to fill your shopping address details.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ShippingPage()));
                      },
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                    ),
                  ],
                ));
      }
    }

    final cart = Provider.of<Cart>(context);

    return BottomAppBar(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                ),
                Text(
                  //'\$210',
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4C53A5),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                checkout(cart);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF4C53A5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Check Out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
