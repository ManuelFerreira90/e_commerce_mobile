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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:e_commerce_mobile/components/card_carrosel_products.dart';
import 'package:e_commerce_mobile/components/card_carrosel.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    //required this.userLogged,
  });

  //final User userLogged;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  List<BannerModel> listBanners = [];
  List<CardCarroselProducts> salesCard = [];
  List<CardCarroselProducts> allProductsCard = [];
  List<CardCarrosel> cards = [];
  Map<String, dynamic> cardMap = {};

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchApi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.white,
        toolbarHeight: 80,
        leadingWidth: 300,
        leading: Container(
          margin: const EdgeInsets.only(left: 15),
          child: AnimSearchBar(
            onSubmitted: (value) {
              print(value);
            },
            width: 400,
            textController: _searchController,
            onSuffixTap: () {
              setState(() {
                _searchController.clear();
              });
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: CircleAvatar(
              radius: 25.0,
              onBackgroundImageError: (_, __) => IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ProfilePage(
                  //         userLogged: widget.userLogged,
                  //       ),
                  //     ),
                  //   );
                  //
                },
              ),
              backgroundImage: NetworkImage(
                '',
                scale: 10, // Adjust the scale as needed
              ),
              // backgroundImage: NetworkImage(
              //   widget.userLogged.image ?? '',
              // ),
            ),
          ),
        ],
      ),
      body: Container(
        //color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            BannerCarousel(
              borderRadius: 30,
              activeColor: kColorSlider,
              banners: listBanners
            ),
            const SizedBox(height: 20),
            CarrosselView(
              cards: cards,
              title: 'Categories',
              width: kWidthCategories,
              height: kHeightCategories,
            ),
            const SizedBox(height: 20),
            CarrosselView(
              cardsWithDiscount: salesCard,
              title: 'Sales',
              width: kWidthSales,
              height: kHeightSales
            ),
            const SizedBox(height: 20),
            CarrosselView(
                cardsWithDiscount: allProductsCard,
                title: 'All Products',
                width: kWidthSales,
                height: kHeightSales
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
  
  fetchApi() async{
    cardMap = await getProductsApi(context);
    final List<CardCarrosel>copyCategories = await getCategoriesApi(context);

    final BannerImages copyImages = BannerImages(listBanners: cardMap['url']);

    setState(() {
      listBanners = copyImages.listBanners;
      cards = copyCategories;
      salesCard = cardMap['sales'];
      allProductsCard = cardMap['allProducts'];
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









