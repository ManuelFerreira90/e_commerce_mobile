import 'package:e_commerce_mobile/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../styles/const.dart';

class CardCarroselWithDiscount extends StatefulWidget {
  CardCarroselWithDiscount({
    super.key,
    required this.width,
    required this.height,
    required this.product,
  });

  final Product product;
  final double width;
  final double height;
  bool isFavorite = false;

  @override
  State<CardCarroselWithDiscount> createState() => _CardCarroselWithDiscountState();
}

class _CardCarroselWithDiscountState extends State<CardCarroselWithDiscount> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: kColorPrimary,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
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
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      widget.product.discountPercentage!.toInt().toString() + '% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80.0,
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      widget.product.category ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  top: 50.0,
                  child: IconButton(
                    onPressed: (){
                      setState(() {
                        widget.isFavorite = !widget.isFavorite;
                      });
                    },
                    icon: Icon(
                      widget.isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
                      color: widget.isFavorite ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.product.title ?? '',
              style: kCategoryStyle,
            ),
            const SizedBox(height: 10),
            Container(
              width: widget.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.product.price!.toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: IconButton(
                        onPressed: (){
                        },
                        icon: Icon(
                            color: Colors.black,
                            Icons.shopping_cart_outlined
                        )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
