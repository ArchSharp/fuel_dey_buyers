import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/notification_card.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
            SizedBox(height: mtop),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Notification",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
            const NotificationCard(
              title: "Available Total Fuel Station",
              location: "Eti-Osa, Lagos, Nigeria",
              distance: "20 Km",
              time: "38 mins",
              imgWidth: 24,
              imgHeight: 44,
            ),
            const SizedBox(height: 15),
            const NotificationCard(
              title: "Available Total Fuel Station",
              location: "Eti-Osa, Lagos, Nigeria",
              distance: "5 Km",
              time: "12 mins",
              imgWidth: 24,
              imgHeight: 44,
            ),
            const SizedBox(height: 15),
            const NotificationCard(
              title: "Available Total Fuel Station",
              location: "Eti-Osa, Lagos, Nigeria",
              distance: "2 Km",
              time: "8 mins",
              imgWidth: 16,
              imgHeight: 30,
            ),
          ],
        ),
      ),
    );
  }
}
