import 'dart:ffi';

import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:flutter/material.dart';
import '../components/card_carrosel_products.dart';
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
  List<CardCarroselProducts> productsCards = [];
  final loading = ValueNotifier(false);
  late final ScrollController _scrollController;
  late List<dynamic> products = [];

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

  infinityScroll() async{
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !loading.value) {
      loading.value = true;
      await _fetchMoreProducts();
      loading.value = false;
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
            onSubmitted: (value) async{
              widget.search = value;
              products = await _searchProducts(value);
              final List<CardCarroselProducts> copyProducts = await ConvertJsonCard.convertJsonProducts(products, widget.isSale ?? false, 30, widget.ssn);
              setState(() {
                productsCards = copyProducts;
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
      body: productsCards.isEmpty ? const Center(
        child: CircularProgressIndicator(
          color: kColorSlider,
        ),
      ) : Stack(
        children: [
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
        ]
      ),
    );
  }

  fetchApi() async{
    switch(widget.choiceView){
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
    final List<CardCarroselProducts> copyProducts = await ConvertJsonCard.convertJsonProducts(products, widget.isSale ?? false, 30, widget.ssn);
    setState(() {
      productsCards = copyProducts;
    });
  }

  _fetchMoreProducts() async{
    if(products.length < 100 && products.length >= 30){
      switch(widget.choiceView){
        case 0:
          products = await getProducts(
              context,
              'https://dummyjson.com/products/category/${widget.category}?limit=$kLimit&skip=${products.length}',
            );
          break;
        case 1:
          products = await getProducts(
              context,
              'https://dummyjson.com/products?limit=$kLimit&skip=${products.length}',
            );
          break;
        case 3:
          products = await getProducts(
              context,
              'https://dummyjson.com/products/search?q=${widget.search}&limit=$kLimit&skip=${products.length}',
            );
          break;
      }
      final List<CardCarroselProducts> copyMore = await ConvertJsonCard.convertJsonProducts(products, widget.isSale ?? false, 30, widget.ssn);
      setState(() {
        productsCards.addAll(copyMore);
      });
    }
  }

  Future<List<dynamic>> _searchProducts(String search) async{
    final List<dynamic> copyProducts = await getProducts(context,
      'https://dummyjson.com/products/search?q=$search',
    );
    return copyProducts;
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


