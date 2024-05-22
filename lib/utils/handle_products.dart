import '../models/product.dart';

class HandleProducts{
  static List<dynamic> orderByDiscount(List<dynamic> products){
    products.sort((a, b) => (b['discountPercentage'] as num).compareTo(a['discountPercentage'] as num));
    return products;
  }

  static List<dynamic> orderByRating(List<dynamic> products){
    products.sort((a, b) => (b['rating'] as num).compareTo(a['rating'] as num));
    return products;
  }
}