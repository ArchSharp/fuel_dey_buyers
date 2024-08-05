import 'dart:async';

import 'package:flutter/material.dart';

class RatingsBar extends StatefulWidget {
  final List<double> ratings;
  final List<String> tips;

  const RatingsBar({
    super.key,
    required this.ratings,
    required this.tips,
  });

  @override
  State<RatingsBar> createState() => _RatingsBarState();
}

class _RatingsBarState extends State<RatingsBar> {
  int? _tappedIndex;
  Timer? _hideTimer;

  void _showTip(int index) {
    setState(() {
      _tappedIndex = index;
    });
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _tappedIndex = null;
      });
    });
  }

  // void _hideTip() {
  //   setState(() {
  //     _tappedIndex = null;
  //   });
  //   _hideTimer?.cancel();
  // }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_tappedIndex != null) {
    //   print("tip: ${widget.tips[_tappedIndex!]}");
    double deviceWidth = MediaQuery.of(context).size.width - 138;
    // }
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            widget.ratings.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RatingBar(
                  rating: widget.ratings[index],
                  tip: widget.tips[index],
                  onTap: () => _showTip(index),
                ),
              );
            },
          ),
        ),
        if (_tappedIndex != null)
          Positioned(
            top: _tappedIndex! * 15,
            left: 0,
            // right: 0,
            child: Container(
              width: deviceWidth,
              // height: 20,
              padding: const EdgeInsets.all(2.0),
              color: Colors.black.withOpacity(0.7),
              child: Text(
                widget.tips[_tappedIndex!],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final String tip;
  static double barLength = 150.0;
  static const double barHeight = 7.0;
  final VoidCallback onTap;

  const RatingBar({
    super.key,
    required this.rating,
    required this.tip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width - 68;
    barLength = deviceWidth - 70;
//    print("tip: $tip");

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: barLength,
        height: barHeight,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(0),
        ),
        child: Stack(
          children: [
            Container(
              width: barLength * rating,
              height: barHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFECB920),
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
