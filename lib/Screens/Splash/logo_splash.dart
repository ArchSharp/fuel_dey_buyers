import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Splash/onboarding.dart';

class LogoSplash extends StatelessWidget {
  const LogoSplash({super.key});
  static const routeName = '/logo-splash';

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // double deviceHeight = MediaQuery.of(context).size.height;
    double imageWidth = deviceWidth * 0.7;
    double imageHeight = imageWidth - 40;
    double exploreBtnWidth = deviceWidth * 0.9;

    return Scaffold(
      body: Container(
        color: Colors.white, //Colors.black.withOpacity(0.87),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/fueldey_logo.png',
                width: imageWidth,
                height: imageHeight,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, Onboarding.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(exploreBtnWidth, 55),
                    backgroundColor: const Color(0xFF018D5C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Explore",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
