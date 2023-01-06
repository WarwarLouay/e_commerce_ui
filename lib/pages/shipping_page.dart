// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, sort_child_properties_last

import 'package:e_commerce_ui/pages/home_page.dart';
import 'package:e_commerce_ui/providers/shipping.dart';
import 'package:e_commerce_ui/widgets/shipping_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  State<ShippingPage> createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  final _formKey = GlobalKey<FormState>();

  String? _address;
  String? _street;
  String? _building;

  var _isLoading = false;

  void getShippingAddres() async {
    final prefs = await SharedPreferences.getInstance();
    _address = prefs.getString("address");
    _street = prefs.getString("street");
    _building = prefs.getString("building");
  }

  @override
  void initState() {
    super.initState();
    getShippingAddres();
  }

  Future<void> save() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });
        form.save();
        await Provider.of<Shipping>(context, listen: false)
            .updateShippingAddress(
          _address!,
          _street!,
          _building!,
        );

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your shipping address has been updated.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                           Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => HomePage()));
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Color(0xFF4C53A5),
                          ),
                        )),
                  ],
                ));
        final prefs = await SharedPreferences.getInstance();
        prefs.reload();
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content:
                      Text('Something went wrong. Please try again later.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'OK',
                          style: TextStyle(
                            color: Color(0xFF4C53A5),
                          ),
                        )),
                  ],
                ));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ShippingAppBar(),
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                'BP Shop',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF4C53A5),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter your address';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) => _address = value!,
                                initialValue: _address,
                                decoration: InputDecoration(
                                  hintText: 'Address',
                                  filled: true,
                                  border: InputBorder.none, //<-- SEE HERE
                                  fillColor: Colors.grey.withOpacity(0.5),
                                  prefixIcon: Icon(
                                    Icons.place,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter your street';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) => _street = value!,
                                initialValue: _street,
                                decoration: InputDecoration(
                                  hintText: 'Street',
                                  filled: true,
                                  border: InputBorder.none, //<-- SEE HERE
                                  fillColor: Colors.grey.withOpacity(0.5),
                                  prefixIcon: Icon(
                                    Icons.route_outlined,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please Enter your building';
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (value) => _building = value!,
                                initialValue: _building,
                                decoration: InputDecoration(
                                  hintText: 'Building',
                                  filled: true,
                                  border: InputBorder.none, //<-- SEE HERE
                                  fillColor: Colors.grey.withOpacity(0.5),
                                  prefixIcon: Icon(
                                    Icons.location_city,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              _isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF4C53A5),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 150,
                                      height: 45,
                                      child: ElevatedButton(
                                        onPressed: save,
                                        child: Text(
                                          'Save',
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF4C53A5)),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4C53A5),
                ),
              );
            }
          }),
    );
  }
}
