import 'package:flutter/material.dart';

class CommuterNotificationCard extends StatelessWidget {
  final String title;
  final String location;
  final String distance;
  final String time;
  final double imgWidth;
  final double imgHeight;

  const CommuterNotificationCard({
    super.key,
    required this.title,
    required this.location,
    required this.distance,
    required this.time,
    required this.imgWidth,
    required this.imgHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      height: 154,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFECB920).withOpacity(0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 94,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFFFFFDF4).withOpacity(0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/car.png',
                  // fit: BoxFit.contain,
                  height: imgHeight,
                  width: imgWidth,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Distance",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      distance,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
