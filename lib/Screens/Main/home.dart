import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Main/main_home.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/commuter_navbar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/commuter_settings.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/notifications.dart';
import 'package:fuel_dey_buyers/Screens/Main/saved.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _navbarIndex = 0;

  void _updateNavbarIndex(int newIndex) {
    setState(() {
      _navbarIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _navbarIndex == 0
            ? const MainHome()
            : _navbarIndex == 1
                ? const Saved()
                : _navbarIndex == 2
                    ? const Notifications()
                    : const CommuterSettings(),
      ),
      bottomNavigationBar: CommuterNavbar(onIndexChanged: _updateNavbarIndex),
    );
  }
}
