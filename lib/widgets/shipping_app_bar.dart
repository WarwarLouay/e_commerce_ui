// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

class ShippingAppBar extends StatelessWidget {
  const ShippingAppBar({super.key});

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
              'Shipping',
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