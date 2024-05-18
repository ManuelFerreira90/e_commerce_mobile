import 'dart:convert';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
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
import 'package:e_commerce_mobile/components/card_carrosel_with_discount.dart';
import 'package:e_commerce_mobile/components/card_carrosel_with_image.dart';
import 'package:e_commerce_mobile/components/card_carrosel.dart';

class BannerImages {
  static const String banner1 =
      "https://picjumbo.com/wp-content/uploads/the-golden-gate-bridge-sunset-1080x720.jpg";
  static const String banner2 =
      "https://cdn.mos.cms.futurecdn.net/Nxz3xSGwyGMaziCwiAC5WW-1024-80.jpg";
  static const String banner3 = "https://wallpaperaccess.com/full/19921.jpg";
  static const String banner4 =
      "https://images.pexels.com/photos/2635817/pexels-photo-2635817.jpeg?auto=compress&crop=focalpoint&cs=tinysrgb&fit=crop&fp-y=0.6&h=500&sharp=20&w=1400";

  static List<BannerModel> listBanners = [
    BannerModel(imagePath: banner1, id: "1"),
    BannerModel(imagePath: banner2, id: "2"),
    BannerModel(imagePath: banner3, id: "3"),
    BannerModel(imagePath: banner4, id: "4"),
  ];
}

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
  List<BannerModel> listBanners = BannerImages.listBanners;
  late List<CardCarroselWithDiscount> salesCard;

  List<CardCarrosel> cards = [
    CardCarrosel(
      title: 'Category 1',
      width: kWidthCategories,
      height: kHeightCategories,
    ),
    CardCarrosel(
      title: 'Category 2',
      width: kWidthCategories,
      height: kHeightCategories,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    getProducts();
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
  
  getProducts() async{
    var url = Uri.https('dummyjson.com', 'products');
    var response = await makeGetRequest(url.toString(), {});

    var overlayEntry = OverlayEntry(builder: (context) => const LoadingOverlay());
    Overlay.of(context).insert(overlayEntry);
    if(response.statusCode == 200){
      Map <String, dynamic> products = await jsonDecode(response.body);
      final List<CardCarroselWithDiscount> copy = await ConvertJsonCard.convertJsonCard(products);
      setState(() {
        salesCard = copy;
      });
    }else{
      handleAPIError(context, response);
    }
    overlayEntry.remove();
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

class CarrosselView extends StatelessWidget {
  CarrosselView({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    this.cards,
    this.cardsWithDiscount,
    this.cardsWithImage,
  });

  final String title;
  final double width;
  final double height;
  final List<CardCarroselWithDiscount>? cardsWithDiscount;
  final List<CardCarroselWithImage>? cardsWithImage;
  final List<CardCarrosel>? cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kTitlesStyle,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cards ?? cardsWithDiscount ?? cardsWithImage ?? [],
          ),
        ),
      ],
    );
  }
}






