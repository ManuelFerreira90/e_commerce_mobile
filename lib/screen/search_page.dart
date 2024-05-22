import 'dart:ffi';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/screen/wrap_page.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:flutter/material.dart';
import '../components/card_carousel_products.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import '../styles/const.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    super.key,
    required this.choiceView,
    this.category,
    this.isSale,
    this.search,
    required this.ssn,
  });

  final String ssn;
  int choiceView;
  final String? category;
  bool? isSale;
  String? search;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<CardCarouselProducts> productsCards = [];
  final loading = ValueNotifier(false);
  late final ScrollController _scrollController;
  late List<dynamic> products = [];
  int sizeProducts = 0;
  bool isLoadingProducts = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(infinityScroll);
    fetchApi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  infinityScroll() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !loading.value) {
      if (sizeProducts < 100 && sizeProducts >= 30) {
        loading.value = true;
        await _fetchMoreProducts();
        loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          margin: const EdgeInsets.only(left: 15),
          child: AnimSearchBar(
            onSubmitted: (value) {
              _onSubmitted(value);
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
      ),
      body: isLoadingProducts
          ? const Center(
              child: CircularProgressIndicator(
                color: kColorSlider,
              ),
            )
          : Stack(children: [
              ListView(
                controller: _scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: productsCards,
                      ),
                    ),
                  ),
                ],
              ),
              loadingIndicatorWidget(),
            ]),
    );
  }

  fetchApi() async {
    setState(() {
      isLoadingProducts = true;
    });
    switch (widget.choiceView) {
      case 0:
        products = await getProducts(
          context,
          'https://dummyjson.com/products/category/${widget.category}',
        );
        break;
      case 1:
        products = await getProducts(
          context,
          'https://dummyjson.com/products',
        );
        break;
      case 2:
        products = await getProducts(
          context,
          'https://dummyjson.com/products',
        );
        break;
      case 3:
        products = await _searchProducts(widget.search!);
        break;
    }
    final List<CardCarouselProducts> copyProducts =
        await ConvertJsonCard.convertJsonProducts(
            products, widget.isSale ?? false, products.length, widget.ssn);

    sizeProducts = products.length;
    setState(() {
      productsCards = copyProducts;
      isLoadingProducts = false;
    });
  }

  _fetchMoreProducts() async {
    switch (widget.choiceView) {
      case 0:
        products = await getProducts(
          context,
          'https://dummyjson.com/products/category/${widget.category}?limit=$kLimit&skip=$sizeProducts',
        );
        break;
      case 1:
        products = await getProducts(
          context,
          'https://dummyjson.com/products?limit=$kLimit&skip=$sizeProducts',
        );
        break;
      case 3:
        products = await getProducts(
          context,
          'https://dummyjson.com/products/search?q=${widget.search}&limit=$kLimit&skip=$sizeProducts',
        );
        break;
    }
    sizeProducts += products.length;
    final List<CardCarouselProducts> copyMore =
        await ConvertJsonCard.convertJsonProducts(
      products,
      widget.isSale ?? false,
      products.length,
      widget.ssn,
    );
    setState(() {
      productsCards.addAll(copyMore);
    });
  }

  Future<List<dynamic>> _searchProducts(String search) async {
    final List<dynamic> copyProducts = await getProducts(
      context,
      'https://dummyjson.com/products/search?q=$search',
    );
    return copyProducts;
  }

  loadingIndicatorWidget() {
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

  _onSubmitted(String search) async {
    setState(() {
      isLoadingProducts = true;
    });

    widget.search = search;
    products = await _searchProducts(search);
    final List<CardCarouselProducts> copyProducts =
        await ConvertJsonCard.convertJsonProducts(
      products,
      widget.isSale ?? false,
      products.length,
      widget.ssn,
    );

    sizeProducts = products.length;
    setState(() {
      productsCards = copyProducts;
    });

    setState(() {
      isLoadingProducts = false;
    });
  }
}
