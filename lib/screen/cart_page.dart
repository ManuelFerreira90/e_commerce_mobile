import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/card_cart_page.dart';
import 'package:flutter/material.dart';
import '../components/card_carrosel_products.dart';
import '../styles/const.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    super.key,
    required this.ssn,
  });

  final String ssn;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CardCarroselProducts> cartProducts = [];
  late List<dynamic> products;
  late ScrollController _scrollController;
  final loading = ValueNotifier(false);

  @override
  void initState(){
    super.initState();
    _scrollController = ScrollController();
    fetchApi();
  }

  @override
  void dispose(){
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return cartProducts.isEmpty ? const Center(
    //   child: CircularProgressIndicator(
    //     color: kColorSlider,
    //   ),
    // ) :
    // Stack(
    //     children: [
    //       ListView(
    //         controller: _scrollController,
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Center(
    //               child: Wrap(
    //                 alignment: WrapAlignment.start,
    //                 children: cartProducts,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //       loadingIndicatorWidget(),
    //     ]
    // );
    return CardCartPage(
      ssn: widget.ssn,
      NumberProduct: 1,
    );
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

  fetchApi()async{
    // products = await getProducts(
    //     context,
    //     'https://'
    // )
  }
}
