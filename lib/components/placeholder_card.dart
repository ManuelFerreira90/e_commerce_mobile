import 'package:flutter/material.dart';
import '../styles/const.dart';


class PlaceholderCard extends StatefulWidget {
  const PlaceholderCard({super.key});

  @override
  State<PlaceholderCard> createState() => _PlaceholderCardState();
}

class _PlaceholderCardState extends State<PlaceholderCard>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidthSales,
      height: kHeightSales,
      decoration: BoxDecoration(
        color: kColorPrimary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: const Center(
          child: CircularProgressIndicator(
            color: kColorSlider,
          ),
        ),
      ),
    );
  }
}
