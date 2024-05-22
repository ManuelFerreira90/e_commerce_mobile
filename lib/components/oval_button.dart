import 'package:flutter/material.dart';
import '../styles/const.dart';

class OvalButton extends StatelessWidget {
  const OvalButton({
    super.key,
    required this.function,
    required this.text,
  });

  final String text;
  final VoidCallback? function;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: kColorSlider,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: function ?? (){},
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}