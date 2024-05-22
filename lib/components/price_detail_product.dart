import 'package:e_commerce_mobile/components/discount_container.dart';
import 'package:e_commerce_mobile/models/product.dart';
import 'package:e_commerce_mobile/utils/functions.dart';
import 'package:flutter/material.dart';
import '../styles/const.dart';

class PriceDetailProduct extends StatelessWidget {
  const PriceDetailProduct({
    super.key,
    required this.product,
    this.isSale,
  });

  final Product product;
  final bool? isSale;

  @override
  Widget build(BuildContext context) {
    return (isSale == true)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 15),
                  DiscountContainer(product: product),
                ],
              ),
              Text(
                '\$${calculateDiscount(product)}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green[800],
                ),
              )
            ],
          )
        : Text(
            '\$${product.price}',
            style: TextStyle(
              fontSize: 30,
              color: Colors.green[800],
            ),
          );
  }
}
