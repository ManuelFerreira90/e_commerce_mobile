import 'package:banner_carousel/banner_carousel.dart';
import 'package:e_commerce_mobile/components/card_carrosel.dart';
import 'package:flutter/material.dart';
import '../components/card_carrosel_products.dart';
import '../styles/const.dart';
import '../models/product.dart';
const maxDiscountedProducts = 5;

class ConvertJsonCard {
  static Map<String, dynamic> convertJsonCard(Map<String, dynamic> products) {
    final Map<String, dynamic> cardsMap = {};
    final List<CardCarroselProducts> cardsSale = [];
    final List<CardCarroselProducts> cardsAllProducts = [];
    List<BannerModel> listBanners = [];
    try {
      final productList = products['products'] as List<dynamic>;
      final allProductList = products['products'] as List<dynamic>;

      for (var i=0; i < allProductList.length && i < maxDiscountedProducts; i++) {
        final productAll = allProductList[i];
        final BannerModel banner = BannerModel(
          id: productAll['id'].toString(),
          imagePath: productAll['thumbnail'].toString(),
        );
        listBanners.add(banner);
        cardsAllProducts.add(CardCarroselProducts(
          isSale: false,
          product: Product(
            productAll['id'],
            productAll['title'],
            productAll['description'],
            productAll['price'],
            productAll['discountPercentage'],
            productAll['rating'],
            productAll['stock'],
            productAll['brand'],
            productAll['category'],
            productAll['thumbnail'],
            productAll['images'],
          ),
          width: kWidthSales,
          height: kHeightSales,
        ));
      }

      productList.sort((a, b) => (b['discountPercentage'] as num).compareTo(a['discountPercentage'] as num));
      for (var i = 0; i < productList.length && i < maxDiscountedProducts; i++) {
        final product = productList[i];
        cardsSale.add(CardCarroselProducts(
          isSale: true,
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
      print('Erro ao analisar produtos: $error');
      // Trate o erro adequadamente (por exemplo, exiba um indicador de carregamento)
    }
    cardsMap['sales'] = cardsSale;
    cardsMap['allProducts'] = cardsAllProducts;
    cardsMap['url'] = listBanners;
    return cardsMap;
  }

  static List<CardCarroselProducts> convertJsonProducts(Map<String, dynamic> products, bool isSale) {
    List<CardCarroselProducts> cards = [];
    try {
      final productList = products['products'] as List<dynamic>;
      for (var product in productList) {
        cards.add(CardCarroselProducts(
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

  static List<CardCarrosel> convertJsonCategories(List<dynamic> categories) {
    List<CardCarrosel> cards = [];
    try {
      for (var category in categories) {
        cards.add(CardCarrosel(
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

