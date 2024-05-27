import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_mobile/components/card_carousel.dart';
import 'package:e_commerce_mobile/components/card_product_cart.dart';
import 'package:e_commerce_mobile/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../components/card_carousel_products.dart';
import '../styles/const.dart';
import '../models/product.dart';

const maxDiscountedProducts = 5;

class ConvertJsonCard {

  static List<GestureDetector> getListImage(BuildContext context, String ssn){
    List<GestureDetector> listImage = [];

    listImage.add(
      GestureDetector(
        onTap: () async{
          goToProductDetailFromSliderImage(context, ssn, '78');
        },
        child: ImageBanner(url: 'https://cdn.dummyjson.com/products/images/laptops/Apple%20MacBook%20Pro%2014%20Inch%20Space%20Grey/1.png',),
      )
    );

    listImage.add(
        GestureDetector(
          onTap: ()async{
            goToProductDetailFromSliderImage(context, ssn, '7');
          },
          child: ImageBanner(url: 'https://cdn.dummyjson.com/products/images/fragrances/Chanel%20Coco%20Noir%20Eau%20De/1.png',),
        )
    );

    listImage.add(
        GestureDetector(
          onTap: (){
            goToProductDetailFromSliderImage(context, ssn, '8');
          },
          child: ImageBanner(url: "https://cdn.dummyjson.com/products/images/fragrances/Dior%20J'adore/1.png",),
        )
    );

    listImage.add(
        GestureDetector(
          onTap: (){
            goToProductDetailFromSliderImage(context, ssn, '186');
          },
          child: ImageBanner(url: 'https://cdn.dummyjson.com/products/images/womens-shoes/Calvin%20Klein%20Heel%20Shoes/1.png',),
        )
    );

    return listImage;
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

class ImageBanner extends StatelessWidget {
  const ImageBanner({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image(
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.image_not_supported_outlined);
      },
      image: CachedNetworkImageProvider(
        url,
        maxHeight: 300,
        maxWidth: 250,
      ),
      width: 300,
      height: 250,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

