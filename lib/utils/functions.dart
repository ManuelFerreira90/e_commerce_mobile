import '../models/product.dart';

calculateDiscount(Product product) {
  final double discount = product.price!.toDouble() * (product.discountPercentage! / 100);
  return (product.price! - discount).toStringAsFixed(2);
}