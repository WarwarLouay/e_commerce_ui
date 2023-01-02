// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'package:e_commerce_ui/pages/login_page.dart';
import 'package:e_commerce_ui/providers/user.dart';
import 'package:e_commerce_ui/widgets/register_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:provider/provider.dart';

import '../exception/http_exception.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _countryPicker = const FlCountryCodePicker();
  CountryCode? _countryCode;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _fullName;
  String? _email;
  String? _country;
  String? _code;
  String? _phone;
  String? _password;
  String? _confirmPassword;

  Future<void> register() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      try {
        form.save();
        await Provider.of<User>(context, listen: false).createAccount(
            _fullName!, _email!, _country!, _code!, _phone!, _password!);

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Your account has been created.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OK')),
                  ],
                ));
      } on HttpException catch (error) {
        if (error.toString().contains('exist')) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text(
                        'This email is already in use. Please use another one.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK')),
                    ],
                  ));
        }
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
                        child: Text('OK')),
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          RegisterAppBar(),
          Container(
            height: MediaQuery.of(context).size.height,
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
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your full name';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _fullName = value!,
                        decoration: InputDecoration(
                          hintText: 'Full Name',
                          filled: true,
                          border: InputBorder.none, //<-- SEE HERE
                          fillColor: Colors.grey.withOpacity(0.5),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your email';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Please Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _email = value!,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          border: InputBorder.none, //<-- SEE HERE
                          fillColor: Colors.grey.withOpacity(0.5),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your phone number';
                          } else if (int.tryParse(value) == null) {
                            return 'Please Enter a valid phone number';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => _phone = value!,
                        decoration: InputDecoration(
                          hintText: 'Your Phone',
                          filled: true,
                          border: InputBorder.none, //<-- SEE HERE
                          fillColor: Colors.grey.withOpacity(0.5),
                          prefixIcon: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            margin: EdgeInsets.only(
                              right: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final code = await _countryPicker
                                        .showPicker(context: context);
                                    setState(() {
                                      _countryCode = code;
                                      _country = code!.name;
                                      _code = code.dialCode;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4C53A5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      _countryCode != null
                                          ? _countryCode!.dialCode
                                          : '+1',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your password';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        controller: _passwordController,
                        onSaved: (value) => _password = value!,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          border: InputBorder.none, //<-- SEE HERE
                          fillColor: Colors.grey.withOpacity(0.5),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF4C53A5),
                          ),
                          suffix: Icon(
                            Icons.visibility,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            return 'Password mismatch';
                          } else {
                            return null;
                          }
                        },
                        obscureText: true,
                        controller: _confirmPasswordController,
                        onSaved: (value) => _confirmPassword = value!,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          filled: true,
                          border: InputBorder.none, //<-- SEE HERE
                          fillColor: Colors.grey.withOpacity(0.5),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF4C53A5),
                          ),
                          suffix: Icon(
                            Icons.visibility,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                        width: 150,
                        height: 45,
                        child: ElevatedButton.icon(
                          onPressed: register,
                          icon: Icon(Icons.account_box_outlined),
                          label: Text(
                            'Create',
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF4C53A5)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(
                        height: 30,
                        color: Color(0xFF4C53A5),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => LoginPage()));
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF4C53A5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
