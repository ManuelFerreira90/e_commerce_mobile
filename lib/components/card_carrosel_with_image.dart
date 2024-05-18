import 'package:flutter/material.dart';
import '../styles/const.dart';

class CardCarroselWithImage extends StatelessWidget {
  const CardCarroselWithImage({
    super.key,
    required this.width,
    required this.height,
    required this.title,
  });

  final String title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kColorPrimary,
      child: Container(
        width: width,
        height: height,
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}