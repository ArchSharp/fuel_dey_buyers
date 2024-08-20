import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Main/main_vendor_home.dart';
import 'package:fuel_dey_buyers/Screens/Main/vendor_notification.dart';
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
  void initState() {
    super.initState();
    _getVendorReviews();
  }

  Future<void> _getVendorReviews() async {
    // print("gotten here: ${widget.vendor['id']}");
    VendorReviewsPayload payload = VendorReviewsPayload(
      vendorId: store.state.user['id'],
    );
    //get vendor reviews
    await getAllVendorReviewsById(payload);
  }

  @override
  Widget build(BuildContext context) {
    // print("_navbarIndex: $_navbarIndex");
    return Scaffold(
      body: _navbarIndex == 0
          ? const MainVendorHome()
          : _navbarIndex == 1
              ? const VendorNotification()
              : const VendorSettings(),
      bottomNavigationBar: VendorNavbar(onIndexChanged: _updateNavbarIndex),
    );
  }
}
