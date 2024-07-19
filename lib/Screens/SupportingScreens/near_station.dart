import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';

class NearStation extends StatelessWidget {
  final String stationName;
  final String location;
  final String estimatedTime;
  final String distance;
  final IconData icon;
  final bool isFuelAvailable;

  const NearStation({
    super.key,
    required this.stationName,
    required this.location,
    required this.estimatedTime,
    required this.distance,
    required this.icon,
    required this.isFuelAvailable,
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
        color: isFuelAvailable ? const Color(0xFFC9C9C9) : Colors.grey[600],
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
                ),
              ),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    estimatedTime,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
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
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // const Spacer(),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 14,
              padding: EdgeInsets.zero,
              icon: const RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.subdirectory_arrow_left,
                  color: Color(0xFF9A9898),
                  size: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, CommuterSignup.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}
