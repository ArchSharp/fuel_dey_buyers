import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static const routeName = '/reset_password';

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool revealPassword = false;
  bool _isAgreeTermsCondition = false;
  bool isButtonClicked = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<int, String> result;

  Future<void> handleSignUp() async {
    setState(() {
      isLoading = true;
    });
    String otp = _otpController.text;
    String newPassword = _passwordController.text;

    try {
      String email = store.state.email;
      Tuple2<int, String> result =
          await resetPasswordFn(otp, newPassword, false);
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

  bool _revealPassword = false;

  final Map<String, String?> _errors = {
    'password': null,
  };

  void _togglePasswordVisibility() {
    setState(() {
      _revealPassword = !_revealPassword;
    });
  }

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
                    "Reset password",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Please enter your new password.",
                  style: TextStyle(fontSize: 16),
                ),
                // Image.asset('assets/images/Ayib.jpg',
                //     width: imageWidth, height: 250),
                const SizedBox(height: 20),
                const Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2C2D2F),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: !_revealPassword,
                  onChanged: (value) {
                    setState(() {
                      // Perform any additional logic when the password changes
                    });
                  },
                  onToggleVisibility: _togglePasswordVisibility,
                  error: _errors['password'],
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.all(0),
                  child: Text("Your password must contain:"),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _isAgreeTermsCondition,
                      checkColor: Colors.black,
                      activeColor: _isAgreeTermsCondition
                          ? const Color(0XFFECB920)
                          : Colors.white,
                      onChanged: (bool? value) {
                        // Handle the state change here
                        setState(() {
                          _isAgreeTermsCondition = !_isAgreeTermsCondition;
                        });
                      },
                    ),
                    const Flexible(
                      child: Text(
                        'at least a number',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _isAgreeTermsCondition,
                      checkColor: Colors.black,
                      activeColor: _isAgreeTermsCondition
                          ? const Color(0XFFECB920)
                          : Colors.white,
                      onChanged: (bool? value) {
                        // Handle the state change here
                        setState(() {
                          _isAgreeTermsCondition = !_isAgreeTermsCondition;
                        });
                      },
                    ),
                    const Flexible(
                      child: Text(
                        'a capital letter',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _validateInputs();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: const Color(0XFFECB920),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Done",
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required Function(String) onChanged,
    required Function() onToggleVisibility,
    required error,
  }) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        errorText: error,
        hintText: "Enter $label",
        border: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
        suffixIcon: GestureDetector(
          onTap: onToggleVisibility,
          child: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    setState(() {
      _errors['password'] = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
    });

    if (_errors.values.every((error) => error == null)) {
      myNotificationBar(context, 'Form submitted', 'success');
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
