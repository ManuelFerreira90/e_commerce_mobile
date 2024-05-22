import 'package:flutter/material.dart';
import '../database/db.dart';
import '../models/product.dart';
import '../styles/const.dart';

class CardProductCart extends StatefulWidget {
  const CardProductCart({
    super.key,
    required this.ssn,
    required this.product,
    required this.removeCardProduct,
  });

  final String ssn;
  final Product product;
  final Function removeCardProduct;

  @override
  State<CardProductCart> createState() => _CardProductCartState();
}

class _CardProductCartState extends State<CardProductCart> {
  late int _counter = 0;

  @override
  void initState(){
    super.initState();
    _initCounter();
  }

  void _initCounter() async {
    final int count = await DB.instance.countProductCart(widget.ssn, widget.product.id!);
    setState(() {
      _counter = count;
    });
  }

  _deleteCard() async{
    await DB.instance.deleteProductCart(widget.product.id!, widget.ssn);
    widget.removeCardProduct(widget.product.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Image.network(
                    width: 180,
                    height: 180,
                    widget.product.thumbnail!
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
                        await DB.instance.updateCart(widget.product.id!, widget.ssn,  (_counter - 1));
                        final int count = _counter - 1;
                        if(count == 0){
                          _deleteCard();
                        }
                        setState(() {
                          _counter = _counter - 1;
                        });
                      },
                    ),
                    Text(
                      '$_counter',
                      style: const TextStyle(
                          color: Colors.white
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await DB.instance.updateCart(widget.product.id!, widget.ssn,  (_counter + 1));
                        setState(() {
                          _counter = _counter + 1;
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