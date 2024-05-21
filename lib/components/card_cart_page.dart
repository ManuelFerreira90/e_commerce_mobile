import 'package:e_commerce_mobile/database/db.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';

class CardCartPage extends StatefulWidget {
  const CardCartPage({
    super.key,
    required this.ssn,
    required this.NumberProduct,
  });

  final String ssn;
  final int NumberProduct;

  @override
  State<CardCartPage> createState() => _CardCartPageState();
}

class _CardCartPageState extends State<CardCartPage> {
  late int _counter = 0;

  @override
  void initState(){
    super.initState();
    _initCounter();
  }

  void _initCounter() async {
    _counter = await DB.instance.countProductCart(widget.ssn, widget.NumberProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.zero,
                child: Card(
                  color: kColorPrimary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          width: 150,
                          height: 150,
                          'https://cdn.dummyjson.com/product-images/4/thumbnail.jpg'
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Product Name',
                                style: TextStyle(
                                  color: Colors.white
                                ),
                            ),
                            SizedBox(height: 15,),
                            Text('\$ 100',
                              style: TextStyle(
                                  color: Colors.green.shade800
                              ),),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  highlightColor: Colors.white,
                                  icon: Icon(Icons.remove,),
                                  onPressed: () async {
                                    await DB.instance.deleteProductCart(widget.NumberProduct, widget.ssn);
                                    setState(() {
                                      _counter--;
                                    });
                                  },
                                ),
                                Text(
                                    '$_counter',
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    //await DB.instance.updateCart(widget.NumberProduct, widget.ssn,  (_counter + 1));
                                    setState(() {
                                      _counter = _counter + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
