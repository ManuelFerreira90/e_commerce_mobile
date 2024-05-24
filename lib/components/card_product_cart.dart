import 'package:e_commerce_mobile/screen/detail_product.dart';
import 'package:flutter/material.dart';
import '../database/db.dart';
import '../models/product.dart';
import '../styles/const.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardProductCart extends StatefulWidget {
  CardProductCart({
    super.key,
    required this.ssn,
    required this.product,
    required this.removeCardProduct,
    required this.setTotalPrice,
  });

  final String ssn;
  final Product product;
  final Function removeCardProduct;
  final Function setTotalPrice;
  int counter = 0;

  @override
  State<CardProductCart> createState() => _CardProductCartState();
}

class _CardProductCartState extends State<CardProductCart> {

  @override
  void initState(){
    super.initState();
    _initCounter();
  }

  void _initCounter() async {
    final int count = await DB.instance.countProductCart(widget.ssn, widget.product.id!);
    setState(() {
      widget.counter = count;
      widget.setTotalPrice(widget.product.price!.toDouble(), 1, count);
    });
  }

  _deleteCard() async{
    setState(() {
      widget.setTotalPrice(widget.product.price!.toDouble(), 0, widget.counter);
    });
    await DB.instance.deleteProductCart(widget.product.id!, widget.ssn);
    widget.removeCardProduct(widget.product.id!);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Card(
        color: kColorPrimary,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailProduct(
                          product: widget.product,
                          ssn: widget.ssn,
                        ),
                      ),
                    );
                  },
                  child: Image(
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.image_not_supported_outlined);
                    },
                      image: CachedNetworkImageProvider(
                          widget.product.thumbnail ?? '',
                          maxHeight: 140,
                          maxWidth: 140,
                      ),
                      width: 140,
                      height: 140,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    widget.product.title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                Text('\$ ${widget.product.price!}',
                  style: TextStyle(
                      color: Colors.green.shade800
                  ),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      highlightColor: Colors.white,
                      icon: const Icon(Icons.remove,),
                      onPressed: () async {
                        await DB.instance.updateCart(widget.product.id!, widget.ssn,  (widget.counter - 1));
                        final int count = widget.counter - 1;
                        if(count == 0){
                          _deleteCard();
                        }
                        setState(() {
                          widget.counter = widget.counter - 1;
                          widget.setTotalPrice(widget.product.price!.toDouble(), 0, 1);
                        });
                      },
                    ),
                    Text(
                      '${widget.counter}',
                      style: const TextStyle(
                          color: Colors.white
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await DB.instance.updateCart(widget.product.id!, widget.ssn,  (widget.counter + 1));
                        setState(() {
                          widget.counter = widget.counter + 1;
                          widget.setTotalPrice(widget.product.price!.toDouble(), 1, 1);
                        });
                      },
                    ),
                  ],
                ),
                IconButton(
                  onPressed: (){
                    _deleteCard();
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red,),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}