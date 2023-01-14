// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:e_commerce_ui/pages/order_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import '../widgets/orders_app_bar.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Cart>(context).fetchOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderItem = Provider.of<Cart>(context);
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          OrdersAppBar(),
          Container(
            height: MediaQuery.of(context).size.height - 140,
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
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: orderItem.orderItem.length,
                    itemBuilder: (context, index) => Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              orderItem.orderItem[index]['_id'],
                            ),
                            subtitle: Text(
                              DateFormat.yMEd().add_jm().format(DateTime.parse(
                                  orderItem.orderItem[index]['date'])),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.chevron_right),
                              onPressed: () {
                                Navigator.pushNamed(context, 'order-details',
                                    arguments: {
                                      'orderProduct': orderItem.orderItem[index]
                                          ['product'],
                                      'shippingAddress':
                                          orderItem.orderItem[index]['shipping']
                                              ['Address'],
                                      'shippingStreet':
                                          orderItem.orderItem[index]['shipping']
                                              ['Street'],
                                      'shippingBuilding':
                                          orderItem.orderItem[index]['shipping']
                                              ['Building'],
                                      'total': orderItem.orderItem[index]['total'],
                                      'status': orderItem.orderItem[index]['status'],
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
