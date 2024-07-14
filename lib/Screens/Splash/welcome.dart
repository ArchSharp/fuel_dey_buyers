import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  static const routeName = "/welcome";

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    // double imageWidth = deviceWidth * 0.4;
    // double imageHeight = imageWidth - 40;
    double exploreBtnWidth = deviceWidth - 40;

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
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        "Welcome",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                      child: Text(
                        "Are you a commuter looking to find the nearest fuel station or a vendor wanting to keep your customers informed, our app has got you covered. Join us to ensure a smooth journey every time you hit the road.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, CommuterSignup.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(exploreBtnWidth, 55),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Sign Up as a Commuter",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "or",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, VendorSignup.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(exploreBtnWidth, 55),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Sign Up as a Vendor",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
