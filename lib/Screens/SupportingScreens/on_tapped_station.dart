import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/star_ratings.dart';

class OnTappedStation extends StatefulWidget {
  final String stationName;
  final String location;
  final String estimatedTime;
  final String distance;
  final IconData icon;
  final bool isFuelAvailable;
  final ValueChanged<int> onIndexChanged;

  const OnTappedStation({
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
  State<OnTappedStation> createState() => _OnTappedStationState();
}

class _OnTappedStationState extends State<OnTappedStation> {
  bool showOpenCloseTime = false;
  bool showAllReview = false;

  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();
  final ValueNotifier<double> _heightPercentageNotifier =
      ValueNotifier<double>(0.5);

  @override
  void initState() {
    super.initState();
    _scrollableController.addListener(() {
      _heightPercentageNotifier.value = _scrollableController.size;
    });
  }

  @override
  void dispose() {
    _scrollableController.removeListener(() {});
    _scrollableController.dispose();
    _heightPercentageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width - 32;
    double deviceHeight = MediaQuery.of(context).size.height;

    double initialHeight = 0.5;
    double minHeight = 0.5;
    double maxHeight = 0.8;

    return DraggableScrollableSheet(
        controller: _scrollableController,
        initialChildSize: initialHeight,
        minChildSize: minHeight,
        maxChildSize: maxHeight,
        builder: (BuildContext context, ScrollController scrollController) {
          return ValueListenableBuilder<double>(
              valueListenable: _heightPercentageNotifier,
              builder: (context, height, child) {
                return Container(
                  height: maxHeight * deviceHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
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
                            // mainAxisSize : MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.circle, // or Icons.brightness_1
                                        size:
                                            10.0, // You can adjust the size as needed
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
                                padding: const EdgeInsets.all(0),
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
                        Row(
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
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height < 0.55 ? 8 : 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
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
                        if (height >= 0.55) const SizedBox(height: 10),
                        if (height >= 0.55)
                          const Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "+234 810 153 2597",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        if (height >= 0.55) const Divider(),
                        if (height >= 0.55)
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Open . Close 10pm",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          showOpenCloseTime =
                                              !showOpenCloseTime;
                                        });
                                      },
                                      icon: Transform.rotate(
                                        angle: showOpenCloseTime
                                            ? 180 * (3.141592653589793 / 180)
                                            : 0 * (3.141592653589793 / 180),
                                        child: const Icon(
                                            Icons.keyboard_arrow_down),
                                      ),
                                    ),
                                  ],
                                ),
                                if (showOpenCloseTime)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
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
                          child: const Row(
                            children: [
                              Icon(
                                Icons.local_gas_station_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
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
                          // padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                        if (height >= 0.55) const Divider(),
                        if (height >= 0.55)
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Review Summary",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "“...very close to the main road for easy access”",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showAllReview = !showAllReview;
                                    });
                                  },
                                  child: const Text(
                                    "See all reviews",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              if (showAllReview)
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "“...very close to the main road for easy access”",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "“...very close to the main road for easy access”",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "“...very close to the main road for easy access”",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "“...very close to the main road for easy access”",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "“...very close to the main road for easy access”",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "“...very close to the main road for easy access”",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              const Divider(),
                              const SizedBox(height: 5),
                              const Text(
                                "Rate and Review",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StarRatings(rating: 3.5),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Your visits and Maps activity",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),

                              // const SizedBox(height: 50)
                            ],
                          ),
                        const SizedBox(height: 15),
                        ElevatedButton(
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
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
