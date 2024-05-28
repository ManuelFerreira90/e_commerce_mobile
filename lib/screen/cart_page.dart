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
  bool isLoading = true;
  double total = 0;

  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setTotalPrice(double price, int operation, int quantity) {
    setState(() {
      if (operation == 1) {
        total += price * quantity;
      } else {
        total -= price * quantity;
      }
    });
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
    } else if(!isLoading && cartProducts.isNotEmpty){
      return Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 25.0, vertical: 10.0),
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: cartProducts,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kColorPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '\$ ${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),

                    ),
                    const SizedBox(height: 20),
                    OvalButton(
                      function: () async {
                        await DB.instance.deleteAllCart(widget.ssn);
                        setState(() {
                          total = 0;
                          cartProducts.clear();
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'All products have been removed from the cart'),
                          ),
                        );
                      },
                      text: 'Remove all',
                    )
                  ],
                ),
              ),
            ]);
    } else {
      return const Center(
        child: Text(
          'No products in the cart',
          style: TextStyle(
            fontSize: 20,
            color: kColorSlider,
          ),
        ),
      );
    }
  }

  removeCardProduct(int numberProduct) {
    if (mounted) {
      setState(() {
        cartProducts
            .removeWhere((element) => element.product.id == numberProduct);
      });
    }
  }

  fetchApi() async {
    List<CardProductCart> copyCartProducts = [];

    final List<String> cart = await DB.instance.readAllCart(widget.ssn);

    for (var i = 0; i < cart.length; i++) {
      products = await getOneProducts(
          context, 'https://dummyjson.com/products/${cart[i]}');
      final CardProductCart? cartProduct =
          ConvertJsonCard.convertJsonOneProductCart(
              products, widget.ssn, removeCardProduct, setTotalPrice);
      if (cartProduct != null) {
        copyCartProducts.add(cartProduct);
      }
    }

    if (mounted) {
      setState(() {
        cartProducts = copyCartProducts;
        isLoading = false;
      });
    }
  }
}
