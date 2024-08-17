import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
// import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_forgotpassword.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signup.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_verify_email.dart';
import 'package:fuel_dey_buyers/Screens/Main/vendor_home.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class VendorSignin extends StatefulWidget {
  const VendorSignin({super.key});
  static const routeName = '/vendor_signin';

  @override
  State<VendorSignin> createState() => _VendorSigninState();
}

class _VendorSigninState extends State<VendorSignin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  String email = '';
  String password = '';

  bool revealPassword = false;
  bool isButtonClicked = false;
  String errorText = '';
  bool isLoading = false;
  int _previousTextLength = 0;
  late Tuple2<int, String> result;

  Future<void> handleSignIn() async {
    setState(() {
      isLoading = true;
    });

    final firstChar = _emailController.text[0];
    final isNumber = RegExp(r'[0-9]').hasMatch(firstChar);
    var processedText = _emailController.text;
    if (isNumber) {
      // Check if the first character is a '+'
      if (processedText[0] == '+') {
        processedText = processedText.substring(1);
      }
      // Check if the first three characters are '234'
      if (processedText.length >= 3 && processedText.substring(0, 3) == '234') {
        processedText = processedText.substring(3);
      }

      // Check if the first character is '0'
      if (processedText.isNotEmpty && processedText[0] == '0') {
        processedText = processedText.substring(1);
      }
    }

    // Create an instance of UserPayload
    UserSignInPayload userPayload = UserSignInPayload(
      email: "+234$processedText",
      password: _passwordController.text,
    );

    // print("email: ${userPayload.email}");

    try {
      store.dispatch(InitialiseEmail(userPayload.email));
      // print("payload: ${userPayload.email}");
      Tuple2<int, String> result = await signInVendorFn(userPayload);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (mounted) {
            myNotificationBar(context, result.item2, "success");
            Navigator.pushReplacementNamed(context, VendorHome.routeName);
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
            if (result.item1 == 2) {
              Navigator.pushReplacementNamed(
                  context, VendorVerifyEmail.routeName);
            }
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _keyboardTypeNotifier =
      ValueNotifier<TextInputType>(TextInputType.text);
  final _emailFocusNode = FocusNode();

  bool _revealPassword = false;

  final Map<String, String?> _errors = {
    'email': null,
    'password': null,
  };

  void _togglePasswordVisibility() {
    setState(() {
      _revealPassword = !_revealPassword;
    });
  }

  // bool _isFirstCharacterNumber(String text) {
  //   if (text.isEmpty) return false;

  //   // Check if the first character is a letter or number
  //   final firstChar = text[0];
  //   final alphabetRegExp = RegExp(r'[A-Za-z]');
  //   // final numberRegExp = RegExp(r'[0-9]');

  //   // return alphabetRegExp.hasMatch(firstChar) || numberRegExp.hasMatch(firstChar);
  //   return alphabetRegExp.hasMatch(firstChar);
  // }

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the initial date
    _emailController.addListener(_updateKeyboardType);
    _initializeTextControllers();
  }

  void _initializeTextControllers() {
    _emailController.addListener(() {
      _clearErrorIfTextPresent('email', _emailController);
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

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.03;
    double exploreBtnWidth = deviceWidth - 40;

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
                    "Welcome back",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                const Text(
                  "Welcome back! We missed you. Log in to continue where you left off.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Email or Phone Number",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 5),
                ValueListenableBuilder<TextInputType>(
                  valueListenable: _keyboardTypeNotifier,
                  builder: (context, keyboardType, child) {
                    return _buildTextField(
                      controller: _emailController,
                      label: 'e.g. abc@gmail.com or 08102723...',
                      error: _errors['email'],
                      keyboardType: keyboardType,
                      focusNode: _emailFocusNode,
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  "Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        if (!isLoading) {
                          Navigator.of(context).pushNamed(
                              VendorForgotpassword.routeName,
                              arguments: 'Passing data from SignIn');
                        }
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF018D5C),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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
                        "Sign In",
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
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height:
                              1, // Adjust the height as needed for the divider
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.black,
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
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
                        child: Container(
                          height:
                              1, // Adjust the height as needed for the divider
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.black,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacementNamed(
                    //     context, CommuterSignup.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(exploreBtnWidth, 55),
                    // backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/google_icon.png',
                        // fit: BoxFit.contain,
                        height: 35,
                        width: 35,
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "Sign In with Google",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pushReplacementNamed(
                    //     context, VendorSignup.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(exploreBtnWidth, 55),
                    // backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(width: 1),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.apple,
                        color: Colors.black,
                        size: 35,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Sign In with Apple",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Don’t have an account?',
                      style: TextStyle(fontSize: 12),
                    ),
                    TextButton(
                      onPressed: () {
                        if (!isLoading) {
                          Navigator.of(context).pushNamed(
                              VendorSignup.routeName,
                              arguments: 'Passing data from SignIn');
                        }
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
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
    required String? error,
    required TextInputType keyboardType,
    required FocusNode focusNode,
  }) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: "Enter $label",
        errorText: error,
        errorStyle: const TextStyle(color: Colors.red),
        border: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        controller.value = controller.value.copyWith(
          text: text.toLowerCase(),
          selection: TextSelection.collapsed(offset: text.length),
        );
      },
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
      _errors['email'] = _emailController.text.isEmpty
          ? 'Please enter your email or phone number'
          : null;
      _errors['password'] = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
    });

    if (_errors.values.every((error) => error == null)) {
      handleSignIn();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _emailController.removeListener(_updateKeyboardType);
    super.dispose();
  }

  void _updateKeyboardType() {
    if (_emailController.text.isEmpty) {
      if (_keyboardTypeNotifier.value != TextInputType.text) {
        _keyboardTypeNotifier.value = TextInputType.text;
        _rebuildTextFieldWithNewKeyboardType();
      }
    } else {
      final firstChar = _emailController.text[0];
      final emailLength = _emailController.text.length;
      final isNumber = RegExp(r'[0-9]').hasMatch(firstChar);
      final newKeyboardType =
          isNumber ? TextInputType.phone : TextInputType.text;

      // Only rebuild the text field if the text length increases and the keyboard type changes
      if (emailLength <= 1) {
        if (_emailController.text.length > _previousTextLength) {
          if (_keyboardTypeNotifier.value != newKeyboardType) {
            _keyboardTypeNotifier.value = newKeyboardType;
            _rebuildTextFieldWithNewKeyboardType();
          }
        } else if (_emailController.text.length <= _previousTextLength) {
          // Update keyboard type without rebuilding if the length decreases
          _keyboardTypeNotifier.value = newKeyboardType;
        }
      }
    }

    // Update the previous text length
    _previousTextLength = _emailController.text.length;
  }

  void _rebuildTextFieldWithNewKeyboardType() {
    // Temporarily lose focus
    _emailFocusNode.unfocus();
    // Set focus again
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    });
  }
}
