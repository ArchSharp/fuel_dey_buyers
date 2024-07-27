import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Splash/logo_splash.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // You can perform any initialization tasks here

    // Example: Delay for 3 seconds and then navigate to the next screen
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, LogoSplash.routeName);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // double deviceHeight = MediaQuery.of(context).size.height;
    double imageWidth = deviceWidth * 0.4;
    double imageHeight = imageWidth - 40;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/images/fuel_pump.png',
                width: imageWidth, height: imageHeight),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: SizedBox(
                width: 20.0, // Adjust the width as needed
                height: 20.0, // Adjust the height as needed
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
