import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signin.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signin.dart';
import 'package:fuel_dey_buyers/Screens/Main/home.dart';
import 'package:fuel_dey_buyers/Screens/Main/vendor_home.dart';
import 'package:fuel_dey_buyers/Screens/Splash/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoSplash extends StatefulWidget {
  const LogoSplash({super.key});
  static const routeName = '/logo-splash';

  @override
  State<LogoSplash> createState() => _LogoSplashState();
}

class _LogoSplashState extends State<LogoSplash> {
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastLogin = prefs.getString('lastLoginTime');
    String? userType = prefs.getString('userType');
    String? userTokenStr = prefs.getString('userToken');
    String? userDataStr = prefs.getString('userData');
    String? isRegistered = prefs.getString('isRegistered');

    await Future.delayed(const Duration(seconds: 3)); // Simulate splash delay

    if (lastLogin != null) {
      DateTime lastLoginTime = DateTime.parse(lastLogin);
      DateTime now = DateTime.now();
      Duration difference = now.difference(lastLoginTime);

      if (difference.inDays >= 90) {
        setState(() {
          firstLoad = false;
        });

        logoutFn();
      } else {
        store.dispatch(UpdateLastLoginTime(lastLoginTime));
        if (userDataStr != null && userTokenStr != null) {
          Map<String, dynamic> userData = jsonDecode(userDataStr);
          Map<String, dynamic> userToken = jsonDecode(userTokenStr);
          store.dispatch(UpdateUserAction(userData));
          store.dispatch(SaveUserToken(userToken));
        }
        if (userType == 'vendor') {
          _redirectTo(VendorHome.routeName);
        } else if (userType == 'commuter') {
          _redirectTo(Home.routeName);
        }
      }
    } else {
      debugPrint("User is not logged in $userType $isRegistered");
      // _redirectTo(Onboarding.routeName);
      if (isRegistered == "true") {
        if (userType == 'vendor') {
          _redirectTo(VendorSignin.routeName);
        } else if (userType == 'commuter') {
          _redirectTo(CommuterSignin.routeName);
        }
      } else {
        setState(() {
          firstLoad = false;
        });
      }
    }
  }

  void _redirectTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

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
                    if (firstLoad) return;
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (firstLoad)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      else
                        const Text(
                          "Explore",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                    ],
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
