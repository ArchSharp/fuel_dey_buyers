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
          "Drive with peace of mind, knowing you’ll never be left to search for fuel again.",
    ),
    OnboardingContent(
      title: "Real-Time Availability",
      description:
          "No more guessing games, just accurate and timely information to keep your journey smooth and uninterrupted.",
    ),
    OnboardingContent(
      title: "Easy Navigation",
      description:
          "Guides you there effortlessly and helps you quickly locate the nearest fuel stations to get petrol, diesel, or gas.",
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: _currentPage < 2
                      ? deviceHeight * 0.15
                      : deviceHeight * 0.18,
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
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              _contents[index].title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              _contents[index].description,
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_contents.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index ? Colors.black : Colors.grey,
                      ),
                    );
                  }),
                ),
                Padding(
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
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_currentPage < _contents.length - 1) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
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
                                  color: Colors.black.withOpacity(0.8),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
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
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Get Started",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
