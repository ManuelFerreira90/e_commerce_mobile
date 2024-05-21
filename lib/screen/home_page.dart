import 'dart:convert';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/carrosel_view.dart';
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
import 'package:e_commerce_mobile/components/card_carrosel_products.dart';
import 'package:e_commerce_mobile/components/card_carrosel.dart';



class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.ssn,
  });

  final String ssn;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerModel> listBannersPreview = [];
  List<CardCarroselProducts> salesCardPreview = [];
  List<CardCarroselProducts> allProductsCardPreview = [];
  List<CardCarrosel> cardsCategories = [];


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
        //color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            BannerCarousel(
              borderRadius: 30,
              activeColor: kColorSlider,
              banners: listBannersPreview
            ),
            const SizedBox(height: 20),
            CarrosselView(
              ssn: widget.ssn,
              cards: cardsCategories,
              title: 'Categories',
              width: kWidthCategories,
              height: kHeightCategories,
            ),
            const SizedBox(height: 20),
            CarrosselView(
              ssn: widget.ssn,
              cardsProducts: salesCardPreview,
              title: 'Sales',
              width: kWidthSales,
              height: kHeightSales,
              isSale: true,
            ),
            const SizedBox(height: 20),
            CarrosselView(
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
    final List<CardCarrosel> copyCategories = await getCategoriesApi(context, widget.ssn);
    final List<CardCarroselProducts> copyAllProducts = await ConvertJsonCard.convertJsonProducts(products, false, 10, widget.ssn);
    final List<dynamic> orderedProductsDiscount = await HandleProducts.orderByDiscount(products);
    final List<CardCarroselProducts> copySales = await ConvertJsonCard.convertJsonProducts(orderedProductsDiscount  , true, 10, widget.ssn);

    setState(() {
      listBannersPreview = copyBanner;
      cardsCategories = copyCategories;
      salesCardPreview = copySales;
      allProductsCardPreview = copyAllProducts;
    });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CheckPage()),
    );
  }

  Future<void> _confirmLogout() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    logout();
                  },
                  child: const Text('Logout')),
            ],
          );
        });
  }
}









