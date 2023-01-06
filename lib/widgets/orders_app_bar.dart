// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore

import 'package:flutter/material.dart';

class OrdersAppBar extends StatefulWidget {
  const OrdersAppBar({super.key});

  @override
  State<OrdersAppBar> createState() => _OrdersAppBarState();
}

class _OrdersAppBarState extends State<OrdersAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          // ignore: prefer_const_constructors
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Orders',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C53A5),
              ),
            ),
          ),
          Spacer(),
          Icon(
              Icons.more_vert,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
        ],
      ),
    );
  }
}