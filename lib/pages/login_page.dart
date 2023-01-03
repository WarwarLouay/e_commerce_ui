// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_field

import 'package:e_commerce_ui/pages/home_page.dart';
import 'package:e_commerce_ui/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../exception/http_exception.dart';
import '../providers/user.dart';
import '../widgets/login_app_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String? _email;
  String? _password;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var _isLoading = false;

  Future<void> login() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<User>(context, listen: false)
            .login(_emailController.text, _passwordController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => HomePage()),
            (route) => false);
      } on HttpException catch (error) {
        if (error.toString().contains('Incorrect email')) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content: Text('Incorrect email. Please create an account.'),
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
        if (error.toString().contains('Incorrect password')) {
          await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Error'),
                    content:
                        Text('Incorrect password. Please create an account.'),
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          LoginAppBar(),
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
                            return 'Please Enter your email';
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Please Enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        controller: _emailController,
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
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter your password';
                          } else {
                            return null;
                          }
                        },
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
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Color(0xFF4C53A5),
                              ),
                            ),
                          ),
                        ],
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
                              child: ElevatedButton.icon(
                                onPressed: login,
                                icon: Icon(Icons.login),
                                label: Text(
                                  'Login',
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF4C53A5)),
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
                            'Don\'t have an account?',
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) => RegisterPage()));
                            },
                            child: Text(
                              'Create One',
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
