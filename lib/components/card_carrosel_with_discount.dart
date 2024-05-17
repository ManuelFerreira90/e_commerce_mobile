import 'package:flutter/material.dart';
import '../styles/const.dart';

class CardCarroselWithDiscount extends StatelessWidget {
  const CardCarroselWithDiscount({
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
      color: kColorPrimary[50],
      child: Stack(
        children: [
          Container(
            width: width,
            height: height,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Text(
                "20%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}