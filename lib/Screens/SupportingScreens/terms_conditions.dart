import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const TermsConditions({
    super.key,
    required this.onIndexChanged,
  });

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  bool isAgreeTermsCondition = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    double mtop = 0.07 * deviceHeight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: mtop),
          Row(
            children: [
              IconButton(
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  widget.onIndexChanged(0);
                },
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 28,
                ),
              ),
              const Spacer(),
              const Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF000000),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Terms and Conditions for Fuel Availability Mobile App",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const Text(
            "1. Introduction Welcome to the Fuel Availability Mobile App. These Terms govern your use of our application and services. By using the app, you agree to these Terms.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "2. Prohibited Activities",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Text(
                "Do not use the app for unlawful activities.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Text(
                "Do not hack, transmit viruses, or disrupt the app’s functionality.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Text(
            "3. Disclaimers and Limitation of Liability",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Text(
                "The app is provided 'as-is' and 'as-available.'",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "We disclaim all warranties and shall not be liable for any damages arising from your use of the app.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "4. Changes to Terms",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "We may modify these Terms at any time, effective immediately upon posting.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "Continued use of the app after changes constitutes acceptance of the new Terms.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "5. Termination",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  "We may terminate or suspend your access at any time for conduct violating these Terms.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const Text(
            "6. Governing Law",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Text(
                "These Terms are governed by the laws of Fuel Que.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 7),
              Icon(
                Icons.circle,
                size: 5,
              ),
              SizedBox(width: 5),
              Text(
                "Disputes shall be resolved in the courts of Fuel Que.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: isAgreeTermsCondition,
                checkColor: const Color(0xFF018D5C),
                activeColor: Colors.white,
                side: BorderSide(
                  width: 2,
                  color: isAgreeTermsCondition
                      ? const Color(0xFF018D5C)
                      : Colors.grey.shade500,
                ),
                onChanged: (bool? value) {
                  // Handle the state change here
                  setState(() {
                    isAgreeTermsCondition = !isAgreeTermsCondition;
                  });
                },
              ),
              Flexible(
                child: RichText(
                  text: TextSpan(
                    text: 'By clicking continue, you agree to our ',
                    style: const TextStyle(
                        color: Colors.black), // Default text style
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms of Service',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF018D5C),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle Terms of Service tap
                          },
                      ),
                      const TextSpan(
                        text: '.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              fixedSize: Size(deviceWidth - 32, 52),
              padding: const EdgeInsets.all(0),
              backgroundColor: const Color(0XFFECB920)
                  .withOpacity(isAgreeTermsCondition ? 1 : 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Accept",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
