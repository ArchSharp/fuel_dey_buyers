import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';

class OnTappedStation extends StatefulWidget {
  final String stationName;
  final String location;
  final String estimatedTime;
  final String distance;
  final IconData icon;
  final bool isFuelAvailable;
  final ValueChanged<int> onIndexChanged;
  final double currentScrolHeight;

  const OnTappedStation({
    super.key,
    required this.stationName,
    required this.location,
    required this.estimatedTime,
    required this.distance,
    required this.icon,
    required this.isFuelAvailable,
    required this.onIndexChanged,
    required this.currentScrolHeight,
  });

  @override
  State<OnTappedStation> createState() => _OnTappedStationState();
}

class _OnTappedStationState extends State<OnTappedStation> {
  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width - 32;
    double deviceHeight = MediaQuery.of(context).size.height;
    double safeHeight = widget.currentScrolHeight;
    double adjustedHeight =
        (deviceHeight - (0.05 * deviceHeight)) * widget.currentScrolHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2,
                  // ),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisSize : MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.circle, // or Icons.brightness_1
                              size: 10.0, // You can adjust the size as needed
                              color: Colors
                                  .black, // You can change the color as needed
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.stationName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Oando Fuel Station',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2D2F),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 14,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.ios_share_outlined,
                          color: Color(0xFFC1C1C1),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/commuter_signup');
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2C2D2F),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        iconSize: 14,
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.favorite_outline_outlined,
                          color: Color(0xFFC1C1C1),
                        ),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/commuter_signup');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2,
                  // ),
                ),
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
                          widget.distance,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          widget.icon,
                          size: 16,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.estimatedTime,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2,
                  // ),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/commuter_signup');
                      },
                    ),
                    Text(
                      widget.location,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2,
                  // ),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.local_gas_station_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/commuter_signup');
                      },
                    ),
                    const Text(
                      "Fuel Type Available:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  // border: Border.all(
                  //   color: Colors.black,
                  //   width: 2,
                  // ),
                ),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, CommuterSignup.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(69, 32),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Petrol",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, CommuterSignup.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(69, 32),
                        backgroundColor: const Color(0xFFC1C1C1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Gas",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, CommuterSignup.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(69, 32),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Diesel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Positioned(
            top: safeHeight < 0.7
                ? 0.87 * adjustedHeight
                : 0.95 * adjustedHeight,
            left: 8,
            right: 8,
            // right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                // border: Border.all(
                //   color: Colors.black,
                //   width: 2,
                // ),
              ),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onIndexChanged(2);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  backgroundColor: const Color(0xFF2C2D2F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Navigate",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Transform.rotate(
                      angle: 50 * (3.141592653589793 / 180),
                      child: const Icon(
                        Icons.navigation_outlined,
                        color: Color(0xFFC9C9C9),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
