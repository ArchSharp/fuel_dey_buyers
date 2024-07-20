import 'package:flutter/material.dart';

class StarRatings extends StatelessWidget {
  final double rating;
  final int starCount;

  const StarRatings({
    super.key,
    this.rating = 0.0,
    this.starCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < starCount; i++) {
      Icon icon;
      if (i < rating.floor()) {
        icon = const Icon(
          Icons.star_rounded,
          color: Color(0xFF2C2D2F),
          size: 27,
        );
      } else if (i < rating && rating % 1 != 0) {
        icon = const Icon(
          Icons.star_half_rounded,
          color: Color(0xFF2C2D2F),
          size: 27,
        );
      } else {
        icon = const Icon(
          Icons.star_border_rounded,
          color: Color(0xFF2C2D2F),
          size: 27,
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
