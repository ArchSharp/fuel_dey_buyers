import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signin.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signin.dart';
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
  bool? isVendor;

  Future<void> handleResetPasswordFn() async {
    setState(() {
      isLoading = true;
    });
    String otp = _otpController.text;
    String newPassword = _passwordController.text;

    try {
      Tuple2<int, String> result =
          await resetPasswordFn(otp, newPassword, isVendor);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (mounted) {
            myNotificationBar(context, result.item2, "success");
            Navigator.pushNamed(
              context,
              isVendor == true
                  ? VendorSignin.routeName
                  : CommuterSignin.routeName,
              arguments: "",
            );
          }
          setState(() {
            isButtonClicked = true;
            errorText = '';
          });

          // You might want to navigate to another screen or perform user registration
        } else {
          // Failed sign-up
          if (mounted) {
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
    // Extract arguments in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        var args = ModalRoute.of(context)?.settings.arguments as String;
        isVendor = args == "Vendor" ? true : false;
      });
    });

    _initializeTextControllers();
  }

  void _initializeTextControllers() {
    _otpController.addListener(() {
      _clearErrorIfTextPresent('otp', _otpController);
    });
    _passwordController.addListener(() {
      _clearErrorIfTextPresent('password', _passwordController);
    });
  }

  void _clearErrorIfTextPresent(
      String field, TextEditingController controller) {
    if (controller.text.isNotEmpty && _errors[field] != null) {
      setState(() {
        _errors[field] = null;
      });
    }
  }

  bool _revealPassword = false;

  final Map<String, String?> _errors = {
    'password': null,
    'otp': null,
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
                  "OTP (one time pin)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2C2D2F),
                  ),
                ),
                const SizedBox(height: 5),
                _buildTextField(
                  controller: _otpController,
                  label: 'OTP',
                  error: _errors['otp'],
                ),
                const SizedBox(height: 10),
                const Text(
                  "New Password",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF2C2D2F),
                  ),
                ),
                const SizedBox(height: 5),
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'New Password',
                  obscureText: !_revealPassword,
                  onChanged: (value) {
                    setState(() {
                      // Perform any additional logic when the password changes
                    });
                  },
                  onToggleVisibility: _togglePasswordVisibility,
                  error: _errors['password'],
                ),
                const SizedBox(height: 30),
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
                // const SizedBox(height: 5),
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
                    if (!isLoading) {
                      FocusScope.of(context).unfocus();
                      _validateInputs();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: const Color(0XFFECB920),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Done",
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                    ],
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
    TextInputType keyboardType = TextInputType.number,
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
      _errors['otp'] =
          _otpController.text.isEmpty ? 'Please enter the received OTP' : null;
    });

    if (_errors.values.every((error) => error == null)) {
      handleResetPasswordFn();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
