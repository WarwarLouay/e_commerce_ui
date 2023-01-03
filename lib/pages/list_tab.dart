// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:e_commerce_ui/pages/login_page.dart';
import 'package:flutter/material.dart';

class ListTab extends StatelessWidget {
  const ListTab({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Center(
        child: ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(15),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => LoginPage()),
                  (route) => false);
            },
            icon: Icon(
              Icons.logout,
              color: Color(0xFF4C53A5),
            ),
            label: Text(
              'Logout',
              style: TextStyle(
                color: Color(0xFF4C53A5),
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
          ),
        ),
      ],
    ));
  }
}
