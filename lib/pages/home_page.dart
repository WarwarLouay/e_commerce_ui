// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:e_commerce_ui/pages/favorire_tab.dart';
import 'package:e_commerce_ui/pages/home_tab.dart';
import 'package:e_commerce_ui/pages/list_tab.dart';
import 'package:e_commerce_ui/providers/shipping.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Widget> _pages;
  int _selectedPageIndex = 1;

  @override
  void initState() {
    _pages = [FavoriteTab(), HomeTab(), ListTab()];
    getShipping();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        color: Color(0xFF4C53A5),
        backgroundColor: Colors.transparent,
        height: 70,
        index: _selectedPageIndex,
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        items: [
          Icon(
            Icons.favorite,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.list,
            size: 30,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
