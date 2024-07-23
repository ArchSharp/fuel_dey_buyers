import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/main_vendor_settings.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/privacy_policy.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/terms_conditions.dart';

class VendorSettings extends StatefulWidget {
  const VendorSettings({super.key});

  @override
  State<VendorSettings> createState() => _VendorSettingsState();
}

class _VendorSettingsState extends State<VendorSettings> {
  int _settingsIndex = 0;

  void _updateSettingsIndex(int newIndex) {
    setState(() {
      _settingsIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _settingsIndex == 0
          ? MainVendorSettings(onIndexChanged: _updateSettingsIndex)
          : _settingsIndex == 1
              ? PrivacyPolicy(onIndexChanged: _updateSettingsIndex)
              : TermsConditions(onIndexChanged: _updateSettingsIndex),
    );
  }
}
