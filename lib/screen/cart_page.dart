import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/card_product_cart.dart';
import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/database/db.dart';
import 'package:e_commerce_mobile/utils/convert_json_card.dart';
import 'package:flutter/material.dart';
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
  List<CardProductCart> cartProducts = [];
  late Map<String, dynamic> products;
  late ScrollController _scrollController;
  bool isLoading = false;

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
    return !isLoading ? const Center(
      child: CircularProgressIndicator(
        color: kColorSlider,
      ),
    ) : Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            child: ListView(
              controller: _scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: cartProducts,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                cartProducts.isEmpty ? const SizedBox.shrink() : OvalButton(
                  function: () async{
                    await DB.instance.deleteAllCart(widget.ssn);
                    setState(() {
                      cartProducts.clear();
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All products have been removed from the cart'),
                      ),
                    );
                  },
                  text: 'Remove all',
                )
              ],
            ),
          ),

        ]
    );
  }

  removeCardProduct(int numberProduct){
    setState(() {
      cartProducts.removeWhere((element) => element.product.id == numberProduct);
    });
  }

  fetchApi() async{
    List<CardProductCart> copyCartProducts = [];

    final List<String> cart = await DB.instance.readAllCart(widget.ssn);

    for (var i = 0; i < cart.length; i++) {
      products = await getOneProducts(
          context,
          'https://dummyjson.com/products/${cart[i]}'
      );
      final CardProductCart? cartProduct = ConvertJsonCard.convertJsonOneProductCart(products, widget.ssn, removeCardProduct);
      if(cartProduct != null){
        copyCartProducts.add(cartProduct);
      }
    }

    setState(() {
      cartProducts = copyCartProducts;
      isLoading = true;
    });
  }
}
