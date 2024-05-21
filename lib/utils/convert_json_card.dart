import 'package:banner_carousel/banner_carousel.dart';
import 'package:e_commerce_mobile/components/card_carrosel.dart';
import 'package:flutter/material.dart';
import '../components/card_carrosel_products.dart';
import '../styles/const.dart';
import '../models/product.dart';
const maxDiscountedProducts = 5;

class ConvertJsonCard {
  static List<BannerModel> convertJsonBanners(List<dynamic> products) {
    List<BannerModel> listBanners = [];
    try {
      final productList = products;
      for (var i = 0; i < productList.length && i < maxDiscountedProducts; i++) {
        final product = productList[i];
        listBanners.add(BannerModel(
          id: product['id'].toString(),
          imagePath: product['thumbnail'].toString(),
        ));
      }
    } catch (error) {
      print('Error parsing banners: $error');
      // Handle the error appropriately (e.g., show a loading indicator)
    }
    return listBanners;
  }

  static List<CardCarroselProducts> convertJsonOneProduct(Map<String, dynamic> products, String ssn) {
    List<CardCarroselProducts> cards = [];
    try {
      final product = products;
      print(product);
      cards.add(CardCarroselProducts(
        ssn: ssn,
        isSale: false,
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
        width: kWidthSales,
        height: kHeightSales,
      ));
    } catch (error) {
      print('Error parsing products: $error');
      // Handle the error appropriately (e.g., show a loading indicator)
    }
    return cards;
  }

  static List<CardCarroselProducts> convertJsonProducts(List<dynamic> products, bool isSale, int limit, String ssn) {
    List<CardCarroselProducts> cards = [];
    try {
      final productList = products;
      for (var i = 0; i < productList.length && i < limit; i++) {
        final product = productList[i];
        cards.add(CardCarroselProducts(
          ssn: ssn,
          isSale: isSale,
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
          width: kWidthSales,
          height: kHeightSales,
        ));
      }
    } catch (error) {
      print('Error parsing products: $error');
      // Handle the error appropriately (e.g., show a loading indicator)
    }
    return cards;
  }

  static List<CardCarrosel> convertJsonCategories(List<dynamic> categories, String ssn) {
    List<CardCarrosel> cards = [];
    try {
      for (var category in categories) {
        cards.add(CardCarrosel(
          ssn: ssn,
          title: category,
          width: kWidthCategories,
          height: kHeightCategories,
        ));
      }
    } catch (error) {
      print('Error parsing categories: $error');
      // Handle the error appropriately (e.g., show a loading indicator)
    }
    return cards;
  }
}

