import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signin.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/privacy_policy.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/terms_conditions.dart';
import 'package:tuple/tuple.dart';

class CommuterSignup extends StatefulWidget {
  const CommuterSignup({super.key});
  static const routeName = '/commuter_signup';

  @override
  State<CommuterSignup> createState() => _CommuterSignupState();
}

class _CommuterSignupState extends State<CommuterSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email = '';
  String firstname = '';
  String lastname = '';
  String mname = '';
  String password = '';
  DateTime? dateofbirth; //DateTime(2023, 01, 27);
  String phoneNumber = "";

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
    CommuterPayload userPayload = CommuterPayload(
      email: _emailController.text,
      password: _passwordController.text,
      firstname: _firstNameController.text,
      lastname: _lastNameController.text,
      // middlename: mname,
      phonenumber: "+234${_phoneController.text}",
    );

    try {
      store.dispatch(InitialiseEmail(email));
      // print("payload: $userPayload");
      Tuple2<int, String> result = await signupCommuterFn(userPayload);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (context.mounted) {
            myNotificationBar(context, result.item2, "success");
            Navigator.pushReplacementNamed(context, CommuterSignin.routeName);
          }
          setState(() {
            isButtonClicked = true;
            errorText = '';
            // isLoading = false;
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
    _initializeTextControllers();
  }

  void _initializeTextControllers() {
    _lastNameController.addListener(() {
      _clearErrorIfTextPresent('lastname', _lastNameController);
    });
    _firstNameController.addListener(() {
      _clearErrorIfTextPresent('firstname', _firstNameController);
    });
    // _middleNameController.addListener(() {
    //   _clearErrorIfTextPresent('middlename', _middleNameController);
    // });
    _emailController.addListener(() {
      _clearErrorIfTextPresent('email', _emailController);
    });
    _phoneController.addListener(() {
      _clearErrorIfTextPresent('phone', _phoneController);
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
  bool _isAgreeTermsCondition = false;

  final Map<String, String?> _errors = {
    'lastname': null,
    'firstname': null,
    // 'middlename': null,
    'phone': null,
    // 'address': null,
    'email': null,
    'password': null,
  };

  void _togglePasswordVisibility() {
    setState(() {
      _revealPassword = !_revealPassword;
    });
  }

  int _signupIndex = 0;

  void _updateHomeIndex(int newIndex) {
    setState(() {
      _signupIndex = newIndex;
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
        child: _signupIndex == 0
            ? Padding(
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
                          "Create account",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome! Let's get you started on your journey. Sign up to unlock a world of possibilities.",
                        style: TextStyle(fontSize: 16),
                      ),
                      // Image.asset('assets/images/Ayib.jpg',
                      //     width: imageWidth, height: 250),
                      const SizedBox(height: 20),
                      const Text(
                        "Last Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name / Surname',
                        error: _errors['lastname'],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "First Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        error: _errors['firstname'],
                      ),
                      const SizedBox(height: 8),
                      // const Text(
                      //   "Middle Name",
                      //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      // ),
                      // const SizedBox(height: 5),
                      // _buildTextField(
                      //   controller: _middleNameController,
                      //   label: 'Middle Name',
                      //   error: _errors['middlename'],
                      // ),
                      // const SizedBox(height: 8),
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        error: _errors['email'],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Phone Number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 65,
                            child: TextFormField(
                              initialValue: '+234',
                              readOnly: true, // Make the field non-editable
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(style: BorderStyle.solid),
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildTextField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              error: _errors['phone'],
                            ),
                          )
                        ],
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
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Checkbox(
                            value: _isAgreeTermsCondition,
                            checkColor: const Color(0xFF018D5C),
                            activeColor: Colors.white,
                            side: BorderSide(
                              width: 2,
                              color: _isAgreeTermsCondition
                                  ? const Color(0xFF018D5C)
                                  : Colors.grey.shade500,
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                _isAgreeTermsCondition = value ?? false;
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
                                        setState(() {
                                          _signupIndex = 1;
                                        });
                                      },
                                  ),
                                  const TextSpan(
                                    text: ' and ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF018D5C),
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Handle Privacy Policy tap
                                        setState(() {
                                          _signupIndex = 2;
                                        });
                                      },
                                  ),
                                  const TextSpan(
                                    text: '.',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (!isLoading && _isAgreeTermsCondition) {
                            _validateInputs();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: const Color(0xFFDEB20A)
                              .withOpacity(_isAgreeTermsCondition ? 1 : 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.black),
                            ),
                            const SizedBox(width: 15),
                            if (isLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: 12),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  CommuterSignin.routeName,
                                  arguments: 'Passing data from SignIn');
                            },
                            child: const Text(
                              "Sign in",
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
              )
            : _signupIndex == 1
                ? TermsConditions(
                    onIndexChanged: _updateHomeIndex,
                  )
                : PrivacyPolicy(
                    onIndexChanged: _updateHomeIndex,
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
      _errors['lastname'] = _lastNameController.text.isEmpty
          ? 'Please enter your last name'
          : null;
      _errors['firstname'] = _firstNameController.text.isEmpty
          ? 'Please enter your first name'
          : null;
      // _errors['middlename'] = _middleNameController.text.isEmpty
      //     ? 'Please enter your middle name'
      //     : null;
      _errors['phone'] = _phoneController.text.isEmpty
          ? 'Please enter your phone number'
          : null;
      // _errors['address'] =
      //     _addressController.text.isEmpty ? 'Please enter your address' : null;
      _errors['email'] =
          _emailController.text.isEmpty ? 'Please enter your email' : null;
      _errors['password'] = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
    });

    if (_errors.values.every((error) => error == null)) {
      handleSignUp();
    }
  }

  @override
  void dispose() {
    _lastNameController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _phoneController.dispose();
    _universityController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
