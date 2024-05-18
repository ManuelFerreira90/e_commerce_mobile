import 'package:e_commerce_mobile/components/card_carrosel.dart';
import 'package:e_commerce_mobile/components/card_carrosel_products.dart';
import 'package:e_commerce_mobile/components/placeholder_card.dart';
import 'package:flutter/material.dart';
import '../styles/const.dart';

class CarrosselView extends StatelessWidget {
  CarrosselView({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    this.cards,
    this.cardsWithDiscount,
  });

  final String title;
  final double width;
  final double height;
  final List<CardCarroselProducts>? cardsWithDiscount;
  final List<CardCarrosel>? cards;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: kTitlesStyle,
            ),
            IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: cards?.length == 0 ||
                cardsWithDiscount?.length == 0 ?
            List.generate(3, (_) => const PlaceholderCard()) :
            cards ?? cardsWithDiscount ?? [],
          ),
        ),
      ],
    );
  }
}