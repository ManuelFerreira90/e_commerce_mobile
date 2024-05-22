import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/card_carousel_products.dart';
import 'package:e_commerce_mobile/database/db.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:flutter/material.dart';
import '../styles/const.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    super.key,
    required this.ssn,
  });

  final String ssn;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<CardCarouselProducts> favoriteProducts = [];


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
    return favoriteProducts.isEmpty ? const Center(
      child: CircularProgressIndicator(
        color: kColorSlider,
      ),
    ) : ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Wrap(
              alignment: WrapAlignment.start,
              children: favoriteProducts,
            ),
          ),
        ),
      ],
    );
  }

  fetchApi() async {
    final List<String> favorite = await DB.instance.readAllFavorites(widget.ssn);
    Map<String, dynamic> products = {};
    List<CardCarouselProducts> copyProducts = [];

    for (var i = 0; i < favorite.length; i++) {
      products = await getOneProducts(
          context,
          'https://dummyjson.com/products/${favorite[i]}',
      );
      copyProducts.addAll(ConvertJsonCard.convertJsonOneProduct(
          products,
          widget.ssn)
      );
    }

    setState(() {
      favoriteProducts = copyProducts;
    });
  }

}
