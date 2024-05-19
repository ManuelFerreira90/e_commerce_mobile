import 'package:e_commerce_mobile/screen/search_page.dart';
import 'package:flutter/material.dart';
import '../styles/const.dart';

class CardCarrosel extends StatelessWidget {
  const CardCarrosel({
    super.key,
    required this.width,
    required this.height,
    required this.title,
  });

  final String title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(choiceView: 0, category: title)));
      },
      child: Card(
        elevation: 5.0,
        color: kColorPrimary,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: width,
            height: height,
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: kCategoryStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}