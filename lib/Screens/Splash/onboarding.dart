import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Splash/welcome.dart';

class OnboardingContent {
  final String title;
  final String description;

  OnboardingContent({
    required this.title,
    required this.description,
  });
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});
  static const routeName = '/onboarding';

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: "Never Get Stuck Again",
      description:
          "Get directions to the nearest station, drive with peace of mind, knowing you’ll never be left to search for fuel again.",
    ),
    OnboardingContent(
      title: "Real-Time Availability",
      description:
          "Stay Updated on the Go. No more guessing games just accurate and timely information to keep your journey smooth and uninterrupted.",
    ),
    OnboardingContent(
      title: "Easy Navigation",
      description:
          "Our intuitive map and search features guides you there effortlessly and helps you quickly locate the nearest fuel stations to get petrol, diesel, or gas.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.4;
    // double imageHeight = imageWidth - 40;
    double exploreBtnWidth = deviceWidth * 0.9;

    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0XFFECB920),
              border: Border.all(
                color: const Color(0XFFECB920),
                width: 0,
              ),
            ),
            child: CurvedTopContainer(
              height: deviceHeight * 0.6,
              slideIndex: _currentPage,
              width: deviceWidth,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0XFFECB920),
                border: Border.all(
                  color: const Color(0XFFECB920),
                  width: 5,
                ),
              ),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(
                  // height: _currentPage < 2
                  //     ? deviceHeight * 0.18
                  //     : deviceHeight * 0.20,
                  // child:
                  SizedBox(
                    height: deviceHeight * 0.4 - 100,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _contents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const SizedBox(height: 10),
                              Text(
                                _contents[index].title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2C2D2F),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                _contents[index].description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF2C2D2F),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  // ),
                  Positioned(
                    bottom: _currentPage < 2 ? 90 : 110,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            _buildIndicator(_currentPage, _contents.length)
                        // List.generate(_contents.length, (index) {
                        //   return Container(
                        //     margin: const EdgeInsets.symmetric(horizontal: 5),
                        //     width: 8,
                        //     height: 8,
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: _currentPage == index
                        //           ? Colors.black
                        //           : Colors.grey,
                        //     ),
                        //   );
                        // }),
                        ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _currentPage < 2
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // Handle skip button press
                                  },
                                  child: const Text(
                                    "Skip",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF2C2D2F),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (_currentPage < _contents.length - 1) {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      print('Current Page: $_currentPage');
                                    } else {
                                      // Handle finish button press
                                    }
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFFFFFDF4), //Colors.black.withOpacity(0.8),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                  ),
                                )
                              ],
                            )
                          : ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, Welcome.routeName);
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(exploreBtnWidth, 55),
                                backgroundColor:
                                    const Color(0xFFFFFDF4), // Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                "Get Started",
                                style: TextStyle(
                                  color: Color(0xFF2C2D2F),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedTopContainer extends StatelessWidget {
  final double height;
  final double width;
  final int slideIndex;

  const CurvedTopContainer({
    super.key,
    required this.height,
    required this.width,
    required this.slideIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedTopClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: Colors.white,
        child: Center(
          child: Image.asset(
            slideIndex == 0
                ? 'assets/images/onboard11.png'
                : slideIndex == 1
                    ? 'assets/images/onboard2.png'
                    : 'assets/images/onboard3.png',
            // fit: BoxFit.contain,
            width: slideIndex == 0
                ? width - 70
                : slideIndex == 1
                    ? width - 170
                    : width - 70,
            height: slideIndex == 0
                ? height * 0.6
                : slideIndex == 1
                    ? height * 0.55
                    : height * 0.5,
          ),
        ),
      ),
    );
  }
}

class CurvedTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // var path = Path();
    // path.lineTo(0, size.height * 0.5);
    // path.quadraticBezierTo(size.width * 0.25, size.height * 0.4,
    //     size.width * 0.5, size.height * 0.5);
    // path.quadraticBezierTo(
    //     size.width * 0.75, size.height * 0.6, size.width, size.height * 0.5);
    // path.lineTo(size.width, 0);
    // path.close();
    // return path;
    var path = Path();
    path.lineTo(0, size.height * 0.80);
    path.quadraticBezierTo(
        size.width * 0.25, size.height, size.width * 0.5, size.height * 0.85);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.7, size.width, size.height * 0.85);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

List<Widget> _buildIndicator(int activePage, int pageCount) {
  final indicators = <Widget>[];

  for (var i = 0; i < pageCount; i++) {
    if (activePage == i) {
      indicators.add(_indicatorsTrue(activePage));
    } else {
      indicators.add(_indicatorsFalse());
    }
  }
  return indicators;
}

Widget _indicatorsTrue(int activePage) {
  // final String color;
  // if (activePage == 0) {
  //   color = '#ff8f4e';
  // } else if (activePage == 1) {
  //   color = '#ff8f4e';
  // } else {
  //   color = '#ff8f4e';
  // }

  // Active Indicator
  return AnimatedContainer(
    duration: const Duration(milliseconds: 300),
    height: 6,
    width: 42,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: const Color(0xFF2C2D2F), //hexToColor(color),
    ),
  );
}

//Inactive Indicator
Widget _indicatorsFalse() {
  return AnimatedContainer(
    duration: const Duration(microseconds: 300),
    height: 8,
    width: 8,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color(0xFFECB920),
        border: Border.all(width: 1)),
  );
}

Color hexToColor(String hex) {
  assert(RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$').hasMatch(hex),
      'Hex color must be #RRGGBB or #AARRGGBB format.');

  if (hex.length == 7) {
    // If the hex string is in the format #RRGGBB, we add the opaque alpha value (FF)
    hex = 'FF${hex.substring(1)}';
  }

  return Color(int.parse(hex.substring(1), radix: 16));
}
