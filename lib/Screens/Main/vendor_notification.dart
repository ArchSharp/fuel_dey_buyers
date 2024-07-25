import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/vendor_notification_card.dart';

class VendorNotification extends StatefulWidget {
  const VendorNotification({super.key});

  @override
  State<VendorNotification> createState() => _VendorNotificationState();
}

class _VendorNotificationState extends State<VendorNotification> {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double mtop = 0.07 * deviceHeight;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: mtop * 0.8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Notification",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFECB920)),
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "All",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Last 7 days",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFACACAC),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const VendorNotificationCard(
              reviewer: "Yemi Lade",
              location: "Eti-Osa, Lagos, Nigeria",
              review:
                  "“The station is very close to the main road for easy access. The prices match the price on the app...”",
              imageUrl: "commuter.png",
            ),
            const SizedBox(height: 15),
            const VendorNotificationCard(
              reviewer: "Yemi Lade",
              location: "Eti-Osa, Lagos, Nigeria",
              review:
                  "“The station is very close to the main road for easy access. The prices match the price on the app...”",
              imageUrl: "commuter.png",
            ),
            const SizedBox(height: 15),
            const VendorNotificationCard(
              reviewer: "Yemi Lade",
              location: "Eti-Osa, Lagos, Nigeria",
              review:
                  "“The station is very close to the main road for easy access. The prices match the price on the app...”",
              imageUrl: "commuter.png",
            ),
            const SizedBox(height: 15),
            const VendorNotificationCard(
              reviewer: "Yemi Lade",
              location: "Eti-Osa, Lagos, Nigeria",
              review:
                  "“The station is very close to the main road for easy access. The prices match the price on the app...”",
              imageUrl: "commuter.png",
            ),
          ],
        ),
      ),
    );
  }
}
