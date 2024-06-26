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
  bool isLoading = true;

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

    return _loadWidget();
  }

  Widget _loadWidget(){
    if(isLoading){
      return const Center(
        child: CircularProgressIndicator(
          color: kColorSlider,
        ),
      );
    } else if(!isLoading && favoriteProducts.isNotEmpty){
     return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: favoriteProducts,
                  ),
                ),
              ],
            );
    } else {
      return const Center(
        child: Text(
          'No favorite products',
          style: TextStyle(
            fontSize: 20,
            color: kColorSlider,
          ),
        ),
      );
    }
  }

  removeProduct(int id) {
    if (mounted) {
      setState(() {
        favoriteProducts.removeWhere((element) => element.product.id == id);
      });
    }
  }

  fetchApi() async {
    final List<String> favorite =
        await DB.instance.readAllFavorites(widget.ssn);
    Map<String, dynamic> products = {};
    List<CardCarouselProducts> copyProducts = [];

    if (mounted) {
      for (var i = 0; i < favorite.length; i++) {
        products = await getOneProducts(
          context,
          'https://dummyjson.com/products/${favorite[i]}',
        );
        copyProducts.addAll(ConvertJsonCard.convertJsonOneProduct(
            products, widget.ssn, removeProduct));
      }
      setState(() {
        favoriteProducts = copyProducts;
        isLoading = false;
      });
    }
  }
}
