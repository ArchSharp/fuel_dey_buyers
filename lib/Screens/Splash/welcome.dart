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

    double exploreBtnWidth = deviceWidth - 40;

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: deviceHeight * 0.5,
            child: Center(
              child: Image.asset(
                'assets/images/welcome2.png',
                width: deviceWidth - 90,
                height: deviceHeight * 0.3,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: deviceWidth,
                decoration: const BoxDecoration(
                  color: Color(0XFFECB920),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                              fontWeight: FontWeight.w700,
                              fontSize: 32,
                              color: Color(0xFF2C2D2F),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            "Are you a commuter looking to find the nearest fuel station or a vendor wanting to keep your customers informed, our app has got you covered. Join us to ensure a smooth journey every time you hit the road.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF2C2D2F),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, CommuterSignup.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(exploreBtnWidth, 52),
                            backgroundColor: const Color(0xFFFFFDF4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Sign Up / Sign In as a Commuter",
                            style: TextStyle(
                              color: Color(0xFF2C2D2F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF2C2D2F),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "or",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF2C2D2F),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(0xFF2C2D2F),
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
                            fixedSize: Size(exploreBtnWidth, 52),
                            backgroundColor: const Color(0xFFFFFDF4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            "Sign Up / Sign In as a Vendor",
                            style: TextStyle(
                              color: Color(0xFF2C2D2F),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
