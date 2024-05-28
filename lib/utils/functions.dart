import 'package:e_commerce_mobile/api/make_request.dart';
import 'package:e_commerce_mobile/components/loading_overlay.dart';
import 'package:e_commerce_mobile/screen/detail_product.dart';
import '../models/product.dart';
import '../styles/const.dart';
import 'package:flutter/material.dart';

calculateDiscount(Product product) {
  final double discount =
      product.price!.toDouble() * (product.discountPercentage! / 100);
  return (product.price! - discount).toStringAsFixed(2);
}

Widget returnWidget(Widget widget, String text, List<dynamic> product,
  bool hasConnection, BuildContext context) {

  verifyConnection(context, hasConnection);  

  return product.isEmpty
      ? Center(
          child: Text(
            text,
            style: const TextStyle(
              color: kColorSlider,
              fontSize: 20,
            ),
          ),
        )
      : widget;
}

verifyConnection(BuildContext context, bool hasConnection){
    if (!hasConnection) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
      ),
    );
  }
}

goToProductDetailFromSliderImage(BuildContext context, String ssn, String id) async {
    var overlayEntry =
    OverlayEntry(builder: (context) => const LoadingOverlay());
    Overlay.of(context).insert(overlayEntry);
    final Map<String, dynamic> productApi = await getOneProducts(
      context,
      'https://dummyjson.com/products/$id',
    );
    final Product product = Product(
      productApi['id'],
      productApi['title'],
      productApi['description'],
      productApi['price'],
      productApi['discountPercentage'],
      productApi['rating'],
      productApi['stock'],
      productApi['brand'],
      productApi['category'],
      productApi['thumbnail'],
      productApi['tags'],
      productApi['images'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                DetailProduct(product: product, ssn: ssn)));
    overlayEntry.remove();
}
