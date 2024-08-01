import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_verify_email.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class CommuterForgotpassword extends StatefulWidget {
  const CommuterForgotpassword({super.key});
  static const routeName = '/commuter_forgotpassword';

  @override
  State<CommuterForgotpassword> createState() => _CommuterForgotpasswordState();
}

class _CommuterForgotpasswordState extends State<CommuterForgotpassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  String email = '';
  String password = '';

  bool revealPassword = false;
  bool isButtonClicked = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<int, String> result;

  Future<void> handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    // Create an instance of UserPayload
    UserSignInPayload userPayload = UserSignInPayload(
      email: email,
      password: password,
    );

    try {
      store.dispatch(InitialiseEmail(email));
      Tuple2<int, String> result = await signinFn(userPayload);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (context.mounted) {
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => const OTPScreen()));
            myNotificationBar(context, result.item2, "success");
          }
          setState(() {
            isButtonClicked = true;
            errorText = '';
          });

          // You might want to navigate to another screen or perform user registration
        } else {
          // Failed sign-up
          if (context.mounted) {
            myNotificationBar(context, result.item2, "error");
          }
          setState(() {
            isButtonClicked = true;
            errorText = result.item2;
          });
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
    // Initialize the text controller with the initial date
  }

  final TextEditingController _emailController = TextEditingController();

  final Map<String, String?> _errors = {
    'email': null,
  };

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.03;
    // double exploreBtnWidth = deviceWidth - 40;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Sign Up'),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: mtop),
                const Padding(
                  padding: EdgeInsets.all(0),
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2C2D2F),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "No worries! Just enter your email, and we'll help you reset it in no time.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2C2D2F),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                // Image.asset('assets/images/Ayib.jpg',
                //     width: imageWidth, height: 250),
                const SizedBox(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF2C2D2F),
                  ),
                ),
                const SizedBox(height: 5),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  error: _errors['email'],
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
                        "Try another way",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF018D5C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _validateInputs();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: const Color(0xFFDEB20A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Color(0xFF2C2D2F),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required error,
  }) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      controller: controller,
      decoration: InputDecoration(
        // labelText: label,
        hintText: "Enter $label",
        errorText: error,
        errorStyle: const TextStyle(color: Colors.red),
        border: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
    );
  }

  void _validateInputs() {
    setState(() {
      _errors['email'] =
          _emailController.text.isEmpty ? 'Please enter your email' : null;
    });

    if (_errors.values.every((error) => error == null)) {
      myNotificationBar(context, 'Form submitted', 'success');
      Navigator.of(context).pushNamed(
        CommuterVerifyEmail.routeName,
        arguments: 'Passing data from SignIn',
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
