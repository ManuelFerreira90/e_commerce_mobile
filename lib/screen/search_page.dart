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

  final int choiceView;
  final String? category;
  bool? isSale;
  String? search;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  List<CardCarroselProducts> products = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    fetchApi();
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
        toolbarHeight: 80,
        title: Container(
          margin: const EdgeInsets.only(left: 15),
          child: AnimSearchBar(
            onSubmitted: (value) {
              _serachProducts(value);
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
      ) : ListView(
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
    );
  }

  fetchApi() async{
    switch(widget.choiceView){
      case 0: // products category
        final List<CardCarroselProducts> copy = await getProductsCategory(context, widget.category!);
        setState(() {
          products = copy;
        });
        break;
      case 1:
        final List<CardCarroselProducts> copy = await getAllProducts(context, widget.isSale!);
        setState(() {
          products = copy;
        });
        break;
      case 2:
        final List<CardCarroselProducts> copy = await getAllProducts(context, widget.isSale!);
        setState(() {
          products = copy;
        });
        break;
      case 3:
        _serachProducts(widget.search!);
        break;
    }
  }

  _serachProducts(String search) async{
    final List<CardCarroselProducts> copy = await getSearchProducts(context, search);
    setState(() {
      products = copy;
    });
  }
}
