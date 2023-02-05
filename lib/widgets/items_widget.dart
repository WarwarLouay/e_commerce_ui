// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, annotate_overrides, prefer_interpolation_to_compose_strings, use_build_context_synchronously, unused_local_variable

import 'package:e_commerce_ui/providers/cart.dart';
import 'package:e_commerce_ui/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({super.key});

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  var _isInit = true;
  var _isLoading = false;
  String? user;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
    user = prefs.getString("uid");
      Provider.of<Product>(context, listen: false).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> update(id) async {
    await Provider.of<Product>(context, listen: false).updateStatus(user!, id!);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Product>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4C53A5),
            ),
          )
        : GridView.builder(
            itemCount: productsData.productItem.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 10,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFF4C53A5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-50%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          update(productsData.productItem[index]['_id']);
                        },
                        child: productsData.productItem[index]['usersFavorite']
                                .contains(user)
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Colors.red,
                              ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'itemPage', arguments: {
                        'id': productsData.productItem[index]['_id'],
                        'image': productsData.productItem[index]
                            ['productImage'],
                        'name': productsData.productItem[index]['productName'],
                        'description': productsData.productItem[index]
                            ['productDescription'],
                        'price': productsData.productItem[index]
                            ['productPrice'],
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Image.network(
                        'http://192.168.0.107:4000' +
                            productsData.productItem[index]['productImage'],
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      productsData.productItem[index]['productName'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$ ${productsData.productItem[index]['productPrice']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Provider.of<Cart>(context, listen: false)
                                .addToCart(
                                    productsData.productItem[index]['_id'], 1);
                          },
                          child: Icon(
                            Icons.shopping_cart_checkout,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.5,
            ),
          );
  }
}
