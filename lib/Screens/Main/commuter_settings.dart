import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/privacy_policy.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/main_commuter_settings.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/terms_conditions.dart';

class CommuterSettings extends StatefulWidget {
  const CommuterSettings({super.key});

  @override
  State<CommuterSettings> createState() => _CommuterSettingsState();
}

class _CommuterSettingsState extends State<CommuterSettings> {
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
          ? MainCommuterSettings(onIndexChanged: _updateSettingsIndex)
          : _settingsIndex == 1
              ? PrivacyPolicy(onIndexChanged: _updateSettingsIndex)
              : TermsConditions(onIndexChanged: _updateSettingsIndex),
    );
  }
}
