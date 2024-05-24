import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/carousel_view.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/components/placeholder_card.dart';
import 'package:e_commerce_mobile/models/product.dart';
import 'package:e_commerce_mobile/screen/detail_product.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:e_commerce_mobile/utils/handle_products.dart';
import 'package:flutter/material.dart';
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
  List<CardCarouselProducts> topCardPreview = [];
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
    return ListView(
      padding: const EdgeInsets.all(10),
      children: [
        BannerCarousel(
            onTap: (id) async {
              var overlayEntry =
                  OverlayEntry(builder: (context) => const LoadingOverlay());
              Overlay.of(context).insert(overlayEntry);
              final Map<String, dynamic> productApi = await getOneProducts(
                context,
                'https://dummyjson.com/products/$id',
              );
              final Product product = Product(
                productApi['id'],
                productApi['title'],
                productApi['description'],
                productApi['price'],
                productApi['discountPercentage'],
                productApi['rating'],
                productApi['stock'],
                productApi['brand'],
                productApi['category'],
                productApi['thumbnail'],
                productApi['tags'],
                productApi['images'],
              );
              if (mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailProduct(product: product, ssn: widget.ssn)));
                overlayEntry.remove();
              }
            },
            borderRadius: 30,
            activeColor: kColorSlider,
            height: 250,
            viewportFraction: 0.8,
            banners: listBannersPreview),
        const SizedBox(height: 20),
        CarouselView(
          ssn: widget.ssn,
          cards: cardsCategories,
          title: 'Categories',
          width: kWidthCategories,
          height: kHeightCategories,
        ),
        const SizedBox(height: 20),
        // CarouselView(
        //   ssn: widget.ssn,
        //   cardsProducts: salesCardPreview,
        //   title: 'Top Products',
        //   width: kWidthSales,
        //   height: kHeightSales,
        // ),
        const Text(
          'Top Products',
          style: kTitlesStyle,
        ),
        const SizedBox(height: 20),
        Wrap(
          runAlignment: WrapAlignment.start,
          children: topCardPreview.isEmpty
              ? List.generate(4, (_) => const PlaceholderCard())
              : topCardPreview,
        ),
        const SizedBox(height: 20),
        const Text(
          'Top Rated',
          style: kTitlesStyle,
        ),
        const SizedBox(height: 20),
        Wrap(
          runAlignment: WrapAlignment.start,
          children: popularCardPreview.isEmpty
              ? List.generate(4, (_) => const PlaceholderCard())
              : popularCardPreview,
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
      'https://dummyjson.com/products',
    );

    final List<BannerModel> copyBanner = ConvertJsonCard.getListBanner();

    final List<dynamic> categories = await getCategoriesApi(context);

    final List<CardCarousel> copyCategories =
        ConvertJsonCard.convertJsonCategories(categories, widget.ssn);

    final List<CardCarouselProducts> copyAllProducts =
        ConvertJsonCard.convertJsonProducts(products, 10, widget.ssn);

    final List<dynamic> orderedProductsRating =
        HandleProducts.orderByRating(products);
    final List<CardCarouselProducts> copyPopular =
        ConvertJsonCard.convertJsonProducts(
            orderedProductsRating, 6, widget.ssn);

    final List<dynamic> orderedProductsPrice =
        HandleProducts.orderByPrice(products);
    final List<CardCarouselProducts> copySales =
        ConvertJsonCard.convertJsonProducts(
      orderedProductsPrice,
      6,
      widget.ssn,
    );
    if (mounted) {
      setState(() {
        listBannersPreview = copyBanner;
        cardsCategories = copyCategories;
        topCardPreview = copySales;
        allProductsCardPreview = copyAllProducts;
        popularCardPreview = copyPopular;
      });
    }
  }
}
