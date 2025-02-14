import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Main/main_home.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/commuter_navbar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/commuter_settings.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/commuter_notifications.dart';
import 'package:fuel_dey_buyers/Screens/Main/saved.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _navbarIndex = 0;
  bool _isShowNavBar = true;

  void _updateNavbarIndex(int newIndex) {
    setState(() {
      _navbarIndex = newIndex;
    });
  }

  void _updateShowNavBar(bool isShowNavBar) {
    setState(() {
      _isShowNavBar = isShowNavBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      body: SafeArea(
        child: _navbarIndex == 0
            ? MainHome(
                onIndexChanged: _updateNavbarIndex,
                onShowNavBarChanged: _updateShowNavBar,
              )
            : _navbarIndex == 1
                ? const Saved()
                : _navbarIndex == 2
                    ? const CommuterNotifications()
                    : const CommuterSettings(),
      ),

      bottomNavigationBar: _isShowNavBar
          ? CommuterNavbar(
              currentIndex: _navbarIndex,
              onIndexChanged: _updateNavbarIndex,
            )
          : null,
    );
  }
}
