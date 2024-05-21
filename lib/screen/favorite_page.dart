import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/card_carrosel_products.dart';
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
  List<CardCarroselProducts> favoriteProducts = [];
  late ScrollController _scrollController;
  final loading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(infinityScroll);
    fetchApi();
  }

  infinityScroll() async{
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !loading.value) {
      loading.value = true;
      //await _fetchMoreProducts();
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return favoriteProducts.isEmpty ? const Center(
    //   child: CircularProgressIndicator(
    //     color: kColorSlider,
    //   ),
    // ) :
    return Stack(
        children: [
          ListView(
            controller: _scrollController,
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
          ),
          loadingIndicatorWidget(),
        ]
    );
  }

  fetchApi() async {
    final List<String> favorite = await DB.instance.readAllFavorites(widget.ssn);
    Map<String, dynamic> products = {};
    List<CardCarroselProducts> copyProducts = [];

    for (var i = 0; i < favorite.length; i++) {
      products = await getOneProducts(
          context,
          'https://dummyjson.com/products/4',
      );
      print(products);
      copyProducts.addAll(ConvertJsonCard.convertJsonOneProduct(products, widget.ssn));
    }

    setState(() {
      favoriteProducts = copyProducts;
    });
  }

  loadingIndicatorWidget(){
    return ValueListenableBuilder(
      valueListenable: loading,
      builder: (context, bool isLoading, _) {
        return (isLoading)
            ? const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              color: kColorSlider,
            ),
          ),
        )
            : const SizedBox();
      },
    );
  }
}
