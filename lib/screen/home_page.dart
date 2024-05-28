import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/carousel_view.dart';
import 'package:e_commerce_mobile/components/placeholder_card.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:flutter/material.dart';
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
  List<CardCarouselProducts> topCardPreview = [];
  List<CardCarouselProducts> allProductsCardPreview = [];
  List<CardCarousel> cardsCategories = [];
  List<CardCarouselProducts> popularCardPreview = [];
  List<GestureDetector> images = [];
  int _currentImageIndex = 0;

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
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            height: 300,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              if (mounted) {
                setState(() => _currentImageIndex = index);
              }
            },
          ),
          items: images,
        ),
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < images.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: _currentImageIndex == i ? 8.0 : 6.0,
                  height: 6.0,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == i ? kColorSlider : Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
            ],
          ),
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
        Column(
          children: [
            const Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Top Products',
                textAlign: TextAlign.start,
                style: kTitlesStyle,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              children: topCardPreview.isEmpty
                  ? List.generate(4, (_) => const PlaceholderCard())
                  : topCardPreview,
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Top Rated',
                style: kTitlesStyle,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              runAlignment: WrapAlignment.start,
              children: popularCardPreview.isEmpty
                  ? List.generate(4, (_) => const PlaceholderCard())
                  : popularCardPreview,
            ),
          ],
        ),
  

        const SizedBox(height: 20),
        CarouselView(
          ssn: widget.ssn,
          cardsProducts: allProductsCardPreview,
          title: 'All Products',
          width: kWidthSales,
          height: kHeightSales,
        ),
      ],
    );
  }

  fetchApi() async {
    final List<dynamic> products = await getProducts(
      context,
      'https://dummyjson.com/products?limit=10&skip=0',
    );

    final List<dynamic> orderedProductsPrice = await getProducts(
      context, 
      'https://dummyjson.com/products?sortBy=price&order=desc&limit=6&skip=0'
    );

    final List<dynamic> orderedProductsRating= await getProducts(
      context, 
      'https://dummyjson.com/products?sortBy=rating&order=desc&limit=6&skip=0'
    );

    final List<GestureDetector> copyImages =
        ConvertJsonCard.getListImage(context, widget.ssn);

    final List<dynamic> categories = await getCategoriesApi(context);

    final List<CardCarousel> copyCategories =
        ConvertJsonCard.convertJsonCategories(categories, widget.ssn);

    final List<CardCarouselProducts> copyAllProducts =
        ConvertJsonCard.convertJsonProducts(products, 10, widget.ssn);

    final List<CardCarouselProducts> copyPopular =
        ConvertJsonCard.convertJsonProducts(
            orderedProductsRating, 6, widget.ssn);
    
    final List<CardCarouselProducts> copySales =
        ConvertJsonCard.convertJsonProducts(
      orderedProductsPrice,
      6,
      widget.ssn,
    );
    if (mounted) {
      setState(() {
        images = copyImages;
        cardsCategories = copyCategories;
        topCardPreview = copySales;
        allProductsCardPreview = copyAllProducts;
        popularCardPreview = copyPopular;
      });
    }
  }
}
