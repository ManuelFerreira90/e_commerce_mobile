import 'package:flutter/material.dart';
import '../styles/const.dart';
import '../models/product.dart';

class DiscountContainer extends StatelessWidget {
  const DiscountContainer({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        '${(product.discountPercentage)} % OFF',
        style: kStyleDiscountText,
      ),
    );
  }
}
