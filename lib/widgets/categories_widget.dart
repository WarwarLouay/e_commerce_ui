// ignore_for_file: prefer_const_constructors, duplicate_ignore, sized_box_for_whitespace, annotate_overrides, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

import '../providers/category.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late Future futureCategories;

  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: 50,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Row(
                  children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              'http://192.168.0.107:4000' + snapshot.data![index].image,
                              width: 40,
                              height: 40,
                            ),
                            // ignore: prefer_const_constructors
                            Text(
                              snapshot.data![index].name,
                              // ignore: prefer_const_constructors
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4C53A5),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4C53A5),
                  ),
            );
        });
  }
}
