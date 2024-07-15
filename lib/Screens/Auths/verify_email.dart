import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_forgotpassword.dart';
import 'package:fuel_dey_buyers/Screens/Auths/reset_password.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});
  static const routeName = '/verify_email';

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
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
    } else {
      Navigator.of(context).pushNamed(
        ResetPassword.routeName,
        arguments: 'Passing data from SignIn',
      );
    }

    setState(() {
      isLoading = true;
    });

    try {
      var email = store.state.email;
      print(email);
      Tuple2<int, String> result = await verifyEmailFn(email, otp);
      if (context.mounted) {
        if (result.item1 == 1) {
          Navigator.of(context).pushNamed(
            ResetPassword.routeName,
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
      print("device width: $deviceWidth");
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
            const SizedBox(height: 20),
            const Text(
              "We sent a 4-digit code verification to mail. Enter the code to continue.",
              style: TextStyle(fontSize: 16),
            ),
            // Image.asset('assets/images/Ayib.jpg',
            //     width: imageWidth, height: 250),
            const SizedBox(height: 20),
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
                    Navigator.of(context).pushNamed(
                        CommuterForgotpassword.routeName,
                        arguments: 'Passing data from SignIn');
                  },
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white),
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
