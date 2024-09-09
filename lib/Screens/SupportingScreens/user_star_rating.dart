import 'package:flutter/material.dart';

class UserStarRating extends StatefulWidget {
  final double initialRating;
  final int starCount;
  final double starSize;
  final ValueChanged<double> onRatingChanged;

  const UserStarRating({
    super.key,
    this.initialRating = 0.0,
    this.starCount = 5,
    this.starSize = 32,
    required this.onRatingChanged,
  });

  @override
  State<UserStarRating> createState() => _UserStarRatingState();
}

class _UserStarRatingState extends State<UserStarRating> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    for (int i = 0; i < widget.starCount; i++) {
      Icon icon;
      if (i < _currentRating.floor()) {
        icon = Icon(
          Icons.star_rounded,
          color: const Color(0xFFECB920),
          size: widget.starSize,
        );
      } else if (i < _currentRating && _currentRating % 1 != 0) {
        icon = Icon(
          Icons.star_half_rounded,
          color: const Color(0xFFECB920),
          size: widget.starSize,
        );
      } else {
        icon = Icon(
          Icons.star_border_rounded,
          color: const Color(0xFF2C2D2F),
          size: widget.starSize,
        );
      }
      stars.add(
        GestureDetector(
          onTap: () {
            setState(() {
              _currentRating = i + 1.0;
            });
            widget.onRatingChanged(_currentRating);
          },
          child: icon,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: stars,
    );
  }
}
