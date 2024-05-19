import 'dart:ffi';

import 'package:e_commerce_mobile/api/make_request.dart';
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
  });

  int choiceView;
  final String? category;
  bool? isSale;
  String? search;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<CardCarroselProducts> products = [];
  final loading = ValueNotifier(false);
  late final ScrollController _scrollController;

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
            onSubmitted: (value) {
              widget.search = value;
              _searchProducts(value);
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
      body: products.isEmpty ? const Center(
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
                  children: products,
                ),
              ),
            ),
          ],
        ),
        ValueListenableBuilder(
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
        ),
        ]
      ),
    );
  }



  fetchApi() async{
    switch(widget.choiceView){
      case 0: // products category
        final List<CardCarroselProducts> copy = await getProducts(
            context,
            'https://dummyjson.com/products/category/${widget.category}',
            widget.isSale ?? false,
        );
        setState(() {
          products = copy;
        });
        break;
      case 1:
        final List<CardCarroselProducts> copy = await getProducts(
            context,
            'https://dummyjson.com/products',
            widget.isSale!
        );
        setState(() {
          products = copy;
        });
        break;
      // case 2:
      //   final List<CardCarroselProducts> copy = await getProducts(
      //       context,
      //       'https://dummyjson.com/products',
      //       widget.isSale!
      //   );
      //   setState(() {
      //     products = copy;
      //   });
      //  break;
      case 3:
        _searchProducts(widget.search!);
        break;
    }
  }

  _fetchMoreProducts() async{
    if(products.length < 100 && products.length >= 30){
      List<CardCarroselProducts> copyMore = [];
      switch(widget.choiceView){
        case 0:
            copyMore = await getProducts(
              context,
              'https://dummyjson.com/products/category/${widget.category}?limit=$kLimit&skip=${products.length}',
              widget.isSale ?? false,
            );
          break;
        case 1:
            copyMore = await getProducts(
              context,
              'https://dummyjson.com/products?limit=$kLimit&skip=${products.length}',
              widget.isSale ?? false,
            );
          break;
        case 3:
            copyMore = await getProducts(
              context,
              'https://dummyjson.com/products/search?q=${widget.search}&limit=$kLimit&skip=${products.length}',
              widget.isSale ?? false,
            );
          break;
      }
      setState(() {
        products.addAll(copyMore);
      });
    }
  }

  _searchProducts(String search) async{
    final List<CardCarroselProducts> copy = await getProducts(context,
      'https://dummyjson.com/products/search?q=$search',
      false);
    setState(() {
      products = copy;
    });
  }
}
