import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Main/main_vendor_home.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/vendor_navbar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/vendor_settings.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});
  static const routeName = '/vendor_home';

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int _navbarIndex = 0;

  void _updateNavbarIndex(int newIndex) {
    setState(() {
      _navbarIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("_navbarIndex: $_navbarIndex");
    return Scaffold(
      body: _navbarIndex == 0 ? const MainVendorHome() : const VendorSettings(),
      bottomNavigationBar: VendorNavbar(onIndexChanged: _updateNavbarIndex),
    );
  }
}
