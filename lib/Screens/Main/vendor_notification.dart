import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
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

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store, //store.state.user
      builder: (context, state /*user*/) {
        var allreviews = store.state.allVendorReviews;

        List<Widget> generatedWidgets =
            List.generate(allreviews.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: VendorNotificationCard(
              reviewer: "Yemi Lade",
              location: "Eti-Osa, Lagos, Nigeria",
              review: "“${allreviews[index]['review']}...”",
              imageUrl: "commuter.png",
            ),
          );
        });

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
                if (allreviews.isNotEmpty) ...generatedWidgets,
                if (allreviews.isEmpty)
                  const Center(
                    child: Text("No reviews yet!!!"),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
