import 'package:e_commerce_mobile/components/card_carrosel.dart';
import 'package:e_commerce_mobile/components/card_carrosel_products.dart';
import 'package:e_commerce_mobile/components/placeholder_card.dart';
import 'package:e_commerce_mobile/screen/search_page.dart';
import 'package:flutter/material.dart';
import '../styles/const.dart';

class CarrosselView extends StatelessWidget {
  CarrosselView({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    this.cards,
    this.cardsProducts,
    this.isSale,
    required this.ssn,
  });

  final String ssn;
  final String title;
  final double width;
  final double height;
  final List<CardCarroselProducts>? cardsProducts;
  final List<CardCarrosel>? cards;
  final bool? isSale;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  choiceView: 1,
                  isSale: isSale!,
                  ssn: ssn,
                ),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: kTitlesStyle,
              ),
              const SizedBox(width: 10),
              cardsProducts != null ? Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              ) : SizedBox.shrink(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cards?.length == 0 ||
                cardsProducts?.length == 0 ?
            List.generate(3, (_) => const PlaceholderCard()) :
            cards ?? cardsProducts ?? [],
          ),
        ),
      ],
    );
  }
}