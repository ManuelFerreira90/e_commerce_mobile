import '../models/product.dart';
import '../styles/const.dart';
import 'package:flutter/material.dart';

calculateDiscount(Product product) {
  final double discount =
      product.price!.toDouble() * (product.discountPercentage! / 100);
  return (product.price! - discount).toStringAsFixed(2);
}

Widget returnWidget(Widget widget, String text, List<dynamic> product,
  bool hasConnection, BuildContext context) {

  verifyConnection(context, hasConnection);  

  return product.isEmpty
      ? Center(
          child: Text(
            text,
            style: const TextStyle(
              color: kColorSlider,
              fontSize: 20,
            ),
          ),
        )
      : widget;
}

verifyConnection(BuildContext context, bool hasConnection){
    if (!hasConnection) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
      ),
    );
  }
}
