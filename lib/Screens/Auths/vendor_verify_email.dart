import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signin.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class VendorVerifyEmail extends StatefulWidget {
  const VendorVerifyEmail({super.key});
  static const routeName = '/vendor_verify_email';

  @override
  State<VendorVerifyEmail> createState() => _VendorVerifyEmailState();
}

class _VendorVerifyEmailState extends State<VendorVerifyEmail> {
  late Tuple2<int, String> result;
  late List<TextEditingController> controllers;
  int currentIndex = 0;
  bool isLoading = false;
  bool resendOtp = false;

  Future<void> verifyOTP() async {
    String otp = controllers.map((controller) => controller.text).join();
    // Implement your OTP verification logic here
    print('Verifying OTP: $otp');

    if (otp.isEmpty || otp.length < 6) {
      String msg = otp.isNotEmpty && otp.length < 6
          ? 'OTP must be six digits'
          : 'OTP must be provided';
      myNotificationBar(context, msg, "error");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var email = store.state.email;
      print(email);
      Tuple2<int, String> result = await verifyEmailFn(email, otp, true);
      if (context.mounted) {
        if (result.item1 == 1) {
          Navigator.of(context).pushNamed(
            VendorSignin.routeName,
            arguments: 'Passing data from SignIn',
          );
          myNotificationBar(context, result.item2, "success");
        } else if (result.item1 == 2) {
          setState(() {
            resendOtp = true;
          });
          myNotificationBar(context, result.item2, "error");
        } else {
          myNotificationBar(context, result.item2, "error");
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendVerifyEmail() async {
    setState(() {
      isLoading = true;
    });

    try {
      var email = store.state.email;
      // print("email: $email");
      Tuple2<int, String> result = await resendVerifyEmailFn(email, true);
      if (context.mounted) {
        if (result.item1 == 1) {
          setState(() {
            resendOtp = false;
          });
          myNotificationBar(context, result.item2, "success");
        } else if (result.item1 == 2) {
          myNotificationBar(context, result.item2, "error");
        } else {
          myNotificationBar(context, result.item2, "error");
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.03;
    // double exploreBtnWidth = deviceWidth - 40;
    double otpBoxWidth = 45;
    if (deviceWidth < 502) {
      //print("device width: $deviceWidth");
      otpBoxWidth = (13.33 / 100) * deviceWidth;
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: mtop),
            const Padding(
              padding: EdgeInsets.all(0),
              child: Text(
                "Verify your email",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // const SizedBox(height: 20),
            const Text(
              "We sent a 6-digit code verification to your phone number. Enter the code to continue.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF2C2D2F),
              ),
            ),
            // Image.asset('assets/images/Ayib.jpg',
            //     width: imageWidth, height: 250),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                6,
                (index) =>
                    buildDigitField(controllers[index], index, otpBoxWidth),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    if (resendOtp == true) {
                      FocusScope.of(context).unfocus();
                      resendVerifyEmail();
                    }
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      fontSize: resendOtp ? 17 : 12,
                      color: const Color(0xFF018D5C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!resendOtp && !isLoading) {
                  FocusScope.of(context).unfocus();
                  verifyOTP();
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor:
                    const Color(0XFFECB920).withOpacity(resendOtp ? 0.3 : 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Confirm",
                    style: TextStyle(
                      color: Color(0xFF2C2D2F),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 15),
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDigitField(
      TextEditingController controller, int index, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          } else {
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
      ),
    );
  }
}
