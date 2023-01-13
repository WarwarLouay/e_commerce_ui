// ignore_for_file: prefer_const_constructors, duplicate_ignore

import 'package:e_commerce_ui/providers/product.dart';
import 'package:e_commerce_ui/widgets/favorite_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Product>(context).fetchFavorite().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> update(id) async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString("uid");
    await Provider.of<Product>(context, listen: false).updateStatus(user!, id!);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteItem = Provider.of<Product>(context);
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        FavoriteAppBar(),
        Container(
          height: MediaQuery.of(context).size.height - 70,
          padding: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Color(0xFFEDECF2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4C53A5),
                  ),
                )
              : GridView.builder(
                  itemCount: favoriteItem.favoriteItem.length,
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
                                update(favoriteItem.favoriteItem[index]
                                    ['product']['_id']);
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'itemPage',
                                arguments: {
                                  'id': favoriteItem.favoriteItem[index]
                                      ['product']['_id'],
                                  'image': favoriteItem.favoriteItem[index]
                                      ['product']['productImage'],
                                  'name': favoriteItem.favoriteItem[index]
                                      ['product']['productName'],
                                  'description':
                                      favoriteItem.favoriteItem[index]
                                          ['product']['productDescription'],
                                  'price': favoriteItem.favoriteItem[index]
                                      ['product']['productPrice'],
                                });
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Image.network(
                              'http://192.168.0.107:4000' +
                                  favoriteItem.favoriteItem[index]['product']
                                      ['productImage'],
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            favoriteItem.favoriteItem[index]['product']
                                ['productName'],
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
                                '\$ ${favoriteItem.favoriteItem[index]['product']['productPrice']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4C53A5),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await Provider.of<Cart>(context,
                                          listen: false)
                                      .addToCart(
                                          favoriteItem.favoriteItem[index]
                                              ['product']['_id'],
                                          1);
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
                ),
        ),
      ],
    );
  }
}
