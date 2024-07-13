import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static const routeName = "/welcome";

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: deviceHeight * 0.4),
          Container(
            height: deviceHeight * 0.6,
            width: deviceWidth,
            // color: Colors.grey,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(128, 128, 128, 0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 40, 16, 8),
                  child: Text(
                    "Welcome",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    "Are you a commuter looking to find the nearest fuel station or a vendor wanting to keep your customers informed, our app has got you covered. Join us to ensure a smooth journey every time you hit the road.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
