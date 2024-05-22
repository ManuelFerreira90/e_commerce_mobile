import 'package:e_commerce_mobile/components/category_container.dart';
import 'package:e_commerce_mobile/components/discount_container.dart';
import 'package:e_commerce_mobile/models/product.dart';
import 'package:e_commerce_mobile/screen/detail_product.dart';
import 'package:e_commerce_mobile/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../styles/const.dart';
import '../database/db.dart';

class CardCarouselProducts extends StatefulWidget {
  const CardCarouselProducts({
    super.key,
    required this.width,
    required this.height,
    required this.product,
    required this.isSale,
    required this.ssn,
  });

  final String ssn;
  final Product product;
  final double width;
  final double height;
  final bool isSale;

  @override
  State<CardCarouselProducts> createState() => _CardCarouselProductsState();
}

class _CardCarouselProductsState extends State<CardCarouselProducts> {

  @override
  void initState() {
    super.initState();
  }
  
  _getPrice(Product product) {
    if (widget.isSale) {
      return calculateDiscount(widget.product);
    } else {
      return product.price;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProduct(
                product: widget.product,
                ssn: widget.ssn,
                isSale: widget.isSale,
            ),
          ),
        );

      },
      child: Container(
        width: widget.width,
        height: 260,
        child: Card(
          elevation: 5.0,
          color: kColorPrimary,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:  const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                      child: Image.network(
                        widget.product.thumbnail ?? '',
                        width: widget.width,
                        height: widget.height,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    widget.isSale
                        ? Positioned(
                            top: 0.0,
                            right: 0.0,
                            child: DiscountContainer(product: widget.product),
                          )
                        : const SizedBox.shrink(),
                    Positioned(
                      top: 75.0,
                      child: CategoryContainer(product: widget.product),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 120,
                  child: Text(
                    widget.product.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: kCategoryStyle,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: widget.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${_getPrice(widget.product)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                          fontSize: 14.0,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: IconButton(
                            onPressed: () async{
                              final bool isExist = await DB.instance.existCart(widget.product.id!, widget.ssn);
                              if(isExist){
                                final int quantity = await DB.instance.countProductCart(widget.ssn, widget.product.id!);
                                await DB.instance.updateCart(widget.product.id!, widget.ssn, (quantity + 1));
                              }else{
                                await DB.instance.createProductCart(widget.product.id!, widget.ssn);
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Product added to cart')
                              ));
                            },
                            icon: const Icon(
                                color: Colors.black,
                                Icons.shopping_cart_outlined)
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



