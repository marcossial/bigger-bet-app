import 'package:flutter/material.dart';

class BiggerBetLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;

  const BiggerBetLogo({
    super.key,
    this.width,
    this.height = 70,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/biggerbet_logo.png',
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }
}