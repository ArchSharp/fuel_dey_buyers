import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_forgotpassword.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/Main/home.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class CommuterSignin extends StatefulWidget {
  const CommuterSignin({super.key});
  static const routeName = '/commuter_signin';

  @override
  State<CommuterSignin> createState() => _CommuterSigninState();
}

class _CommuterSigninState extends State<CommuterSignin> {
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with the initial date
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
                const SizedBox(height: 20),
                const Text(
                  "Welcome back! We missed you. Log in to continue where you left off.",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 5),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  error: _errors['email'],
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
                        Navigator.of(context).pushNamed(
                            CommuterForgotpassword.routeName,
                            arguments: 'Passing data from SignIn');
                      },
                      child: const Text(
                        "Forgot Password?",
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
                    _validateInputs();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
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
                          height: 1,
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
                    Navigator.pushReplacementNamed(
                        context, CommuterSignup.routeName);
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
                    Navigator.pushReplacementNamed(
                        context, CommuterSignup.routeName);
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
                        Navigator.of(context).pushNamed(
                            CommuterSignup.routeName,
                            arguments: 'Passing data from SignIn');
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
      _errors['email'] =
          _emailController.text.isEmpty ? 'Please enter your email' : null;
      _errors['password'] = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
    });

    if (_errors.values.every((error) => error == null)) {
      myNotificationBar(context, 'Form submitted', 'success');
      Navigator.pushReplacementNamed(context, Home.routeName);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
