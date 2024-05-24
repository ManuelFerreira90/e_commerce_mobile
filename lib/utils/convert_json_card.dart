import 'package:banner_carousel/banner_carousel.dart';
import 'package:e_commerce_mobile/components/card_carousel.dart';
import 'package:e_commerce_mobile/components/card_product_cart.dart';
import 'package:flutter/foundation.dart';
import '../components/card_carousel_products.dart';
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
      if (kDebugMode) {
        print('Error parsing categories: $error');
      }
    }
    return listBanners;
  }

  static List<BannerModel> getListBanner(){
    List<BannerModel> listBanners = [];
    listBanners.add(BannerModel(
      id: '78',
      imagePath: 'https://cdn.dummyjson.com/products/images/laptops/Apple%20MacBook%20Pro%2014%20Inch%20Space%20Grey/1.png',
    ));
    listBanners.add(BannerModel(
      id: '123',
      imagePath: 'https://cdn.dummyjson.com/products/images/smartphones/iPhone%2013%20Pro/thumbnail.png',
    ));
    listBanners.add(BannerModel(
      id: '6',
      imagePath: 'https://cdn.dummyjson.com/products/images/fragrances/Calvin%20Klein%20CK%20One/thumbnail.png',
    ));
    listBanners.add(BannerModel(
      id: '186',
      imagePath: 'https://cdn.dummyjson.com/products/images/womens-shoes/Calvin%20Klein%20Heel%20Shoes/thumbnail.png',
    ));
    return listBanners;
  }

  static List<CardCarouselProducts> convertJsonOneProduct(Map<String, dynamic> products, String ssn, Function? remove) {
    List<CardCarouselProducts> cards = [];
    try {
      final product = products;
      cards.add(CardCarouselProducts(
        resetProduct: remove,
        ssn: ssn,
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
          product['tags'],
          product['images'],
        ),
        width: kWidthSales,
        height: kHeightSales,
      ));
    } catch (error) {
      if (kDebugMode) {
        print('Error parsing categories: $error');
      }
    }
    return cards;
  }

  static CardProductCart? convertJsonOneProductCart(Map<String, dynamic> products, String ssn, Function removeCardProduct, Function setTotalPrice) {
    final CardProductCart card;
    try {
      final product = products;
      card = CardProductCart(
        setTotalPrice: setTotalPrice,
        removeCardProduct: removeCardProduct,
        ssn: ssn,
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
          product['tags'],
          product['images'],
        ),
      );
      return card;
    } catch (error) {
      if (kDebugMode) {
        print('Error parsing categories: $error');
      }
    }
    return null;
  }

  static List<CardCarouselProducts> convertJsonProducts(List<dynamic> products, int limit, String ssn) {
    List<CardCarouselProducts> cards = [];
    try {
      final productList = products;
      for (var i = 0; i < productList.length && i < limit; i++) {
        final product = productList[i];
        cards.add(CardCarouselProducts(
          ssn: ssn,
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
            product['tags'],
            product['images'],
          ),
          width: kWidthSales,
          height: kHeightSales,
        ));
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error parsing categories: $error');
      }
    }
    return cards;
  }

  static List<CardCarousel> convertJsonCategories(List<dynamic> categories, String ssn) {
    List<CardCarousel> cards = [];
    try {
      for (var category in categories) {
        cards.add(CardCarousel(
          ssn: ssn,
          title: category,
          width: kWidthCategories,
          height: kHeightCategories,
        ));
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error parsing categories: $error');
      }
    }
    return cards;
  }
}

