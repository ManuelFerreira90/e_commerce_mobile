import 'package:e_commerce_mobile/api/request_api_search.dart';
import 'package:e_commerce_mobile/main.dart';
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
  int sizeProducts = 0;
  int totalProductsApi = 0;
  bool isLoadingProducts = true;
  bool hasConnection = true;
  final dropValue = ValueNotifier('');
  final filterOptions = ['price down', 'price up', 'title down', 'title up', 'rating down', 'rating up'];
  String sortBy = '';
  String order = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(infinityScroll);
    _initLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _initLoad() async {
    await fetchApi();
    setState(() {
      isLoadingProducts = false;
    });
  }

  infinityScroll() async {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !loading.value) {
      if (sizeProducts < totalProductsApi && sizeProducts >= 30) {
        loading.value = true;
        await fetchApi();
        loading.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    this.hasConnection = hasConnection;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Container(
          margin: const EdgeInsets.only(left: 15),
          child: AnimSearchBar(
            onSubmitted: (value) async {
              sizeProducts = 0;
              productsCards.clear();
              widget.search = value;
              dropValue.value = '';
              sortBy = '';
              order = '';
              widget.choiceView = 3;
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
      body: _loadWidget(),
    );
  }

  Widget _loadWidget() {
    if (isLoadingProducts && hasConnection) {
      return const Center(
        child: CircularProgressIndicator(
          color: kColorSlider,
        ),
      );
    } else if (!isLoadingProducts &&
        hasConnection &&
        productsCards.isNotEmpty) {
      return Stack(children: [
        ListView(
          controller: _scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                      valueListenable: dropValue,
                      builder: (BuildContext context, String value, _) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SizedBox(
                            width: 180,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              isExpanded: true,
                              hint: const Text('Filter'),
                              value: (value.isEmpty) ? null : value,
                              onChanged: (option) async{
                                    dropValue.value = option.toString();
                                    productsCards.clear();
                                    sizeProducts = 0;
                                    List<String>? words = option?.split(" ");
                                    if(words != null){
                                      sortBy = words[0];
                                      if(words[1] == 'down') {
                                        order = 'desc';
                                      }
                                      else {
                                        order = 'asc';
                                      }
                                    }
                              
                                  setState(() {
                                    isLoadingProducts = true;
                                  });
                                  await fetchApi();
                                  setState(() {
                                    isLoadingProducts = false;
                                  });
                              },
                              items: filterOptions
                                  .map((op) => DropdownMenuItem(
                                        value: op,
                                        child: Text(op),
                                      ))
                                  .toList(),
                            ),
                          ),
                        );
                      }),
                  dropValue.value != '' ? IconButton(
                    onPressed: ()async {
                      dropValue.value = '';
                      productsCards.clear();
                      sizeProducts = 0;
                      sortBy = '';
                      order = '';
                      setState(() {
                        isLoadingProducts = true;
                      });
                      await fetchApi();
                      setState(() {
                        isLoadingProducts = false;
                      });

                    }, 
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.white,),
                  ) : const SizedBox(),
                ],
              ),
            ),
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
      ]);
    } else if (!hasConnection) {
      return const Center(
        child: Text('No internet connection',
            style: TextStyle(
              color: kColorSlider,
              fontSize: 20,
            )),
      );
    } else {
      return const Center(
        child: Text('No results found',
            style: TextStyle(
              color: kColorSlider,
              fontSize: 20,
            )),
      );
    }
  }

  fetchApi() async {
    Map<String, dynamic> response = {};
    List<dynamic> products = [];

    switch (widget.choiceView) {
      case 0:
        response = await RequestApiSearch.getProductsSearchCategory(
            context, widget.category!, 30, sizeProducts, sortBy, order);
        break;
      case 1:
        response = await RequestApiSearch.getAllProductsSearch(
            context, 30, sizeProducts, sortBy, order);
        break;
      case 3:
        response = await RequestApiSearch.getProductsSearch(
            context, widget.search!, 30, sizeProducts, sortBy, order);
        break;
    }
    products = response['products'];
    totalProductsApi = response['total'];

    final List<CardCarouselProducts> copyProducts =
        ConvertJsonCard.convertJsonProducts(
            products, products.length, widget.ssn);

    sizeProducts += copyProducts.length;
    if (mounted) {
      setState(() {
        productsCards.addAll(copyProducts);
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
