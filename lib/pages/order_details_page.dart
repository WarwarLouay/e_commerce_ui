// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, sized_box_for_whitespace, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../widgets/orders_app_bar.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key});
  static const routeName = '/order-details';

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var orderProduct = routeArgs['orderProduct']!;
    var shippingAddress = routeArgs['shippingAddress']!;
    var shippingStreet = routeArgs['shippingStreet']!;
    var shippingBuilding = routeArgs['shippingBuilding']!;
    var total = routeArgs['total']!;
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
            child: Column(
              children: [
                Container(
                  height: 500,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: orderProduct.length,
                    itemBuilder: (context, index) => Column(
                      children: [
                        Container(
                          height: 110,
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                margin: EdgeInsets.only(right: 15),
                                child: Image.network(
                                  'http://192.168.0.107:4000' +
                                      orderProduct[index]['product']
                                          ['productImage'],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderProduct[index]['product']
                                          ['productName'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4C53A5),
                                      ),
                                    ),
                                    Text(
                                      '\$${orderProduct[index]['product']['productPrice']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4C53A5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      '${orderProduct[index]['qty']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF4C53A5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        'Address: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                      Text('${shippingAddress}'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        'Street: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                      Text('${shippingStreet}'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        'Building: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                      Text('${shippingBuilding}'),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5),
                        ),
                      ),
                      Text('\$${total}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
