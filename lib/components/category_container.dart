import 'package:flutter/material.dart';
import '../models/product.dart';

class CategoryContainer extends StatelessWidget {
  const CategoryContainer({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(
        product.category ?? '',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
        ),
      ),
    );
  }
}