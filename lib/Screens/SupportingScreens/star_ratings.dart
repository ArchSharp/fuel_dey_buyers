import 'package:flutter/material.dart';

class StarRatings extends StatelessWidget {
  final double rating;
  final int starCount;
  final double starSize;

  const StarRatings({
    super.key,
    this.rating = 0.0,
    this.starCount = 5,
    this.starSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < starCount; i++) {
      Icon icon;
      if (i < rating.floor()) {
        icon = Icon(
          Icons.star_rounded,
          color: const Color(0xFFECB920),
          size: starSize,
        );
      } else if (i < rating && rating % 1 != 0) {
        icon = Icon(
          Icons.star_half_rounded,
          color: const Color(0xFFECB920),
          size: starSize,
        );
      } else {
        icon = Icon(
          Icons.star_border_rounded,
          color: const Color(0xFF2C2D2F),
          size: starSize,
        );
      }
      stars.add(icon);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: stars,
    );
  }
}
