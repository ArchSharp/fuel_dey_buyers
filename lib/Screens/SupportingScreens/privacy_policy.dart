import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const PrivacyPolicy({
    super.key,
    required this.onIndexChanged,
  });

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
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
                "Privacy Policy",
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
            "Introduction",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Welcome to the Fuel Availability App! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our app.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Information We Collect",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "1. Personal Information: When you register or use our app, we may collect personal information such as your name, email address, phone number, and location.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "2. Usage Data: We collect information on how you interact with our app, including your search queries, pages viewed, and other actions taken within the app.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "3. Device Information: We collect information about the device you use to access our app, including the hardware model, operating system, and unique device identifiers.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "4. Location Information: With your permission, we collect real-time location information to provide you with accurate fuel availability updates.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "How We Use Your Information",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "1. To Provide Services: We use your information to deliver the services you request, such as locating fuel stations and providing real-time fuel availability updates.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "2. To Improve Our Services: We analyze usage data to improve our app’s functionality and user experience.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "3. To Communicate with You: We use your contact information to send you important updates, notifications, and promotional offers.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "4. For Security and Fraud Prevention: We use your information to help maintain the security of our app and prevent fraudulent activities.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Sharing Your Information",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "1. With Service Providers: We may share your information with third-party service providers who help us operate and improve our app.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "2. For Legal Reasons: We may disclose your information if required to do so by law or in response to valid requests by public authorities.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "3. Business Transfers: If we are involved in a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred as part of that transaction.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Your Choices",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "1. Access and Update Your Information: You can access and update your personal information through the app’s settings.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "2. Opt-Out of Communications: You can opt-out of receiving promotional communications from us by following the unsubscribe instructions included in each email.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            "3. Location Information: You can control the collection of location information through your device’s settings.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Security",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no internet or email transmission is ever fully secure or error-free.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Children’s Privacy",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "Our app is not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If we become aware that we have collected personal information from a child under 13, we will take steps to delete such information.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Changes to This Privacy Policy",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Contact Us",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "If you have any questions about this Privacy Policy, please contact us at:",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: isAgreeTermsCondition,
                checkColor: Colors.white,
                activeColor:
                    isAgreeTermsCondition ? Colors.black : Colors.white,
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
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
              backgroundColor: const Color(0xFF2C2D2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text(
              "Accept",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFC9C9C9),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
