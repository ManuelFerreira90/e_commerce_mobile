import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';

class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({super.key});

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: Colors.black,
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(
              color: kColorSlider,
            ),
          ),
        ),
      ],
    );
  }
}