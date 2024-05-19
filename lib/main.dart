import 'package:e_commerce_mobile/screen/check_page.dart';
import 'package:e_commerce_mobile/screen/home_page.dart';
import 'package:e_commerce_mobile/screen/wrap_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData.dark().copyWith(
  textTheme: GoogleFonts.montserratAlternatesTextTheme(),
);


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: lightTheme,
      home: WrapPage(),
    );
  }
}
