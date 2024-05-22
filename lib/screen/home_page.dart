import 'dart:convert';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/carousel_view.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/models/banner_images.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/check_page.dart';
import 'package:e_commerce_mobile/screen/profile_page.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:e_commerce_mobile/utils/handle_api_error.dart';
import 'package:e_commerce_mobile/utils/handle_products.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:e_commerce_mobile/components/card_carousel_products.dart';
import 'package:e_commerce_mobile/components/card_carousel.dart';



class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.ssn,
    required this.imageUser,
  });

  final String ssn;
  final String imageUser;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerModel> listBannersPreview = [];
  List<CardCarouselProducts> salesCardPreview = [];
  List<CardCarouselProducts> allProductsCardPreview = [];
  List<CardCarousel> cardsCategories = [];
  List<CardCarouselProducts> popularCardPreview = [];


  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            BannerCarousel(
              borderRadius: 30,
              activeColor: kColorSlider,
              banners: listBannersPreview
            ),
            const SizedBox(height: 20),
            CarouselView(
              ssn: widget.ssn,
              cards: cardsCategories,
              title: 'Categories',
              width: kWidthCategories,
              height: kHeightCategories,
            ),
            const SizedBox(height: 20),
            CarouselView(
              ssn: widget.ssn,
              cardsProducts: salesCardPreview,
              title: 'Sales',
              width: kWidthSales,
              height: kHeightSales,
              isSale: true,
            ),
            const SizedBox(height: 20),
            CarouselView(
              ssn: widget.ssn,
              cardsProducts: popularCardPreview,
              title: 'Popular',
              width: kWidthSales,
              height: kHeightSales,
              isSale: false,
            ),
            const SizedBox(height: 20),
            CarouselView(
                ssn: widget.ssn,
                cardsProducts: allProductsCardPreview,
                title: 'All Products',
                width: kWidthSales,
                height: kHeightSales,
                isSale: false,
            ),
          ],
        ),
    );
  }
  
  fetchApi() async{
    final List<dynamic> products = await getProducts(
        context,
        'https://dummyjson.com/products',
    );


    final List<BannerModel> copyBanner = ConvertJsonCard.convertJsonBanners(products);

    final List<dynamic> categories = await getCategoriesApi(context);
    final List<CardCarousel> copyCategories = await ConvertJsonCard.convertJsonCategories(
        categories,
        widget.ssn
    );

    final List<CardCarouselProducts> copyAllProducts = await ConvertJsonCard.convertJsonProducts(
        products,
        false,
        10,
        widget.ssn
    );

    final List<dynamic> orderedProductsRating = await HandleProducts.orderByRating(products);
    final List<CardCarouselProducts> copyPopular = await ConvertJsonCard.convertJsonProducts(
        orderedProductsRating,
        false,
        10,
        widget.ssn
    );

    final List<dynamic> orderedProductsDiscount = await HandleProducts.orderByDiscount(products);
    final List<CardCarouselProducts> copySales = await ConvertJsonCard.convertJsonProducts(
        orderedProductsDiscount,
        true,
        10,
        widget.ssn,
    );

    setState(() {
      listBannersPreview = copyBanner;
      cardsCategories = copyCategories;
      salesCardPreview = copySales;
      allProductsCardPreview = copyAllProducts;
      popularCardPreview = copyPopular;
    });
  }
}









