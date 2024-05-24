import 'package:e_commerce_mobile/api/request_api_search.dart';
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
    this.search,
    required this.ssn,
  });

  final String ssn;
  int choiceView;
  final String? category;
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
    isLoadingProducts = false;
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
        await fetchApi();
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
            onSubmitted: (value) async {
              sizeProducts = 0;
              productsCards.clear();
              products.clear();
              widget.search = value;
              setState(() {
                isLoadingProducts = true;
              });
              await fetchApi();
              setState(() {
                isLoadingProducts = false;
              });
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
    switch (widget.choiceView) {
      case 0:
        products += await RequestApiSearch.getProductsSearchCategory(
            context, widget.category!, 30, sizeProducts);
        break;
      case 1:
        products += await RequestApiSearch.getAllProductsSearch(
            context, 30, sizeProducts);
        break;
      case 3:
        products += await RequestApiSearch.getProductsSearch(
          context,
          widget.search!,
          30,
          sizeProducts,
        );
        break;
    }
    final List<CardCarouselProducts> copyProducts =
        ConvertJsonCard.convertJsonProducts(
            products, products.length, widget.ssn);

    sizeProducts = products.length;
    if (mounted) {
      setState(() {
        productsCards = copyProducts;
      });
    }
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
}
