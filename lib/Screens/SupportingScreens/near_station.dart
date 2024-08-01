import 'package:flutter/material.dart';

class NearStation extends StatelessWidget {
  final String stationName;
  final String location;
  final String estimatedTime;
  final String distance;
  final IconData icon;
  final bool isFuelAvailable;
  final ValueChanged<int> onIndexChanged;

  const NearStation({
    super.key,
    required this.stationName,
    required this.location,
    required this.estimatedTime,
    required this.distance,
    required this.icon,
    required this.isFuelAvailable,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 8.0,
      // ),
      height: 70,
      decoration: BoxDecoration(
        color: isFuelAvailable
            ? const Color(0xFF018D5C)
            : const Color(0xFF018D5C).withOpacity(0.5),
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2,
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "EST. TIME",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    estimatedTime,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            height: 20,
            width: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey,
                  Colors.black,
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                stationName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // const Spacer(),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: IconButton(
                alignment: Alignment.center,
                iconSize: 14,
                padding: EdgeInsets.zero,
                icon: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.subdirectory_arrow_left,
                    color: Color(0xFF018D5C),
                    size: 20,
                    // weight: 30,
                  ),
                ),
                onPressed: () {
                  onIndexChanged(1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
