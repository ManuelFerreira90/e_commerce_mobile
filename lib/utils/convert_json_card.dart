import 'package:flutter/material.dart';
import '../components/card_carrosel_with_discount.dart';
import '../styles/const.dart';
import '../models/product.dart';

class ConvertJsonCard {
  static List<CardCarroselWithDiscount> convertJsonCard(Map<String, dynamic> products) {
    List<CardCarroselWithDiscount> cards = [];
    try {
      for (var product in products['products']) {
        cards.add(CardCarroselWithDiscount(
          product: Product(
            product['id'],
            product['title'],
            product['description'],
            product['price'],
            product['discountPercentage'],
            product['rating'],
            product['stock'],
            product['brand'],
            product['category'],
            product['thumbnail'],
            product['images'],
          ),
          width: 200,
          height: 200,
        ));
      }
    } catch (error) {
      print('Error parsing products: $error');
      // Handle the error appropriately (e.g., show a loading indicator)
    }
    return cards;
  }
}
