import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signin.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_verify_email.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/privacy_policy.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/terms_conditions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class VendorSignup extends StatefulWidget {
  const VendorSignup({super.key});
  static const routeName = '/vendor_signup';

  @override
  State<VendorSignup> createState() => _VendorSignupState();
}

class _VendorSignupState extends State<VendorSignup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String stationname = '';
  String address = '';
  String state = '';
  String lga = '';
  String email = '';
  String phone = "";
  String password = '';

  bool revealPassword = false;
  bool isButtonClicked = false;
  String errorText = '';
  bool isLoading = false;
  late Tuple2<int, String> result;

  bool _revealPassword = false;
  bool _isAgreeTermsCondition = false;
  bool _isConfirmAddress = false;
  Position? _currentPosition;
  LatLng? _stationPosition;

  Map<String, dynamic> nigeriaData = {};
  List<dynamic> states = [];
  String? selectedState;
  List<dynamic> lgas = [];
  String? selectedLGA;
  String? lgaLatitude;
  String? lgaLongitude;
  int? postalcode;

  Future<void> handleSignUp() async {
    setState(() {
      isLoading = true;
    });

    // Create an instance of UserPayload
    VendorSignUpPayload userPayload = VendorSignUpPayload(
      stationname: _stationNameController.text.trim(),
      address: _addressController.text.trim(),
      latitude: lgaLatitude!.trim(),
      longitude: lgaLongitude!.trim(),
      postalcode: postalcode!,
      state: selectedState!.trim(),
      lga: selectedLGA!.replaceAll("/", "-").trim(),
      email: _emailController.text.trim(),
      phonenumber: "+234${_phoneController.text.trim()}",
      password: _passwordController.text.trim(),
    );

    if (userPayload.password.length < 8) {
      myNotificationBar(
          context, "Password should be at least 8 characters", "error");
      return;
    }

    try {
      store.dispatch(InitialiseEmail(userPayload.email));
      Tuple2<int, String> result = await signupVendorFn(userPayload);
      if (_formKey.currentState?.validate() ?? false) {
        if (result.item1 == 1) {
          if (mounted) {
            myNotificationBar(context, result.item2, "success");
            Navigator.pushReplacementNamed(
                context, VendorVerifyEmail.routeName);
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
    // Initialize the text controller with the initial date
    _initializeTextControllers();
    loadNigeriaData();
    _checkPermission();
  }

  final TextEditingController _stationNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _lgaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _initializeTextControllers() {
    _stationNameController.addListener(() {
      _clearErrorIfTextPresent('stationname', _stationNameController);
    });
    _addressController.addListener(() {
      _clearErrorIfTextPresent('address', _addressController);
    });
    _stateController.addListener(() {
      _clearErrorIfTextPresent('state', _stateController);
    });
    _lgaController.addListener(() {
      _clearErrorIfTextPresent('lga', _lgaController);
    });
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

  final Map<String, String?> _errors = {
    'station_name': null,
    'address': null,
    'state': null,
    'lga': null,
    'phone': null,
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

  void _getPostalCodeFunc(PostalCodeInfo info) {
    setState(() {
      postalcode = info.postalCode;
      lgaLatitude = info.latitude;
      lgaLongitude = info.longitude;
      // selectedLGA = info.googleLga;
    });
  }

  Future<void> loadNigeriaData() async {
    final String response =
        await rootBundle.loadString('assets/data/nigeria.json');
    final data = await json.decode(response);
    setState(() {
      nigeriaData = data;
      states = nigeriaData['states'];
    });
  }

  Future<void> _checkPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? permissionGranted = prefs.getBool('location_permission_granted');
    if (permissionGranted != null) {
      if (permissionGranted) {
        _getCurrentLocation();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    String address =
        "${place.street} ${place.locality} state ${place.country}, postal code ${place.postalCode}";

    //print("Placemarks: " + placemarks.toString());
    if (mounted) {
      print("address: $address");
      // print("place: $place");
      setState(() {
        _currentPosition = position;
      });
    }
  }

  Future<void> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        double latitude = locations.first.latitude;
        double longitude = locations.first.longitude;

        setState(() {
          _stationPosition = LatLng(latitude, longitude);
        });

        print('$address Geocoding Latitude: $latitude, Longitude: $longitude');
      } else {
        print('No location found for the given address.');
      }
    } catch (e) {
      print('Error occurred while converting address to coordinates: $e');
    }
  }

  // Function to show the modal popup
  void _showModalPopup() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UnconstrainedBox(
          constrainedAxis: Axis.horizontal,
          child: SizedBox(
            width: 200,
            child: Dialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Container(
                color: Colors.white,
                height: 200,
                padding: const EdgeInsets.all(12),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "A map with your address (red pin) will be displayed soon. Please confirm if it's correct. If not, adjust the map by dragging, or zooming, and then tap the closest point that matches your station address.",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    await _getCurrentLocation();

    String address =
        "${_addressController.text} ${_lgaController.text} ${_stateController.text} Nigeria";
    await _getCoordinatesFromAddress(address);

    // Introduce a 10-seconds delay before closing the progress dialog
    await Future.delayed(const Duration(seconds: 20));

    // Close the progress dialog and show the map
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          double deviceWidth = MediaQuery.of(context).size.width * 0.95;

          // print(
          //     "deviceWidth: $deviceWidth, ${deviceWidth * 0.9}, ${_currentPosition?.latitude}");

          // // Future to simulate the delay of obtaining user location
          // Future<Position?> userLocationFuture = Future.delayed(
          //   const Duration(seconds: 1),
          //   () =>
          //       _currentPosition, // Replace this with your method to get user location
          // );
          return UnconstrainedBox(
            constrainedAxis: Axis.horizontal,
            child: SizedBox(
              width: deviceWidth,
              child: Dialog(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Container(
                  height: 430,
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MainWidget(
                        userLocation: _currentPosition,
                        stationCoordinate: _stationPosition,
                        height: 305,
                        width: deviceWidth,
                        getPostalCodeFunc: _getPostalCodeFunc,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: const Color(0XFFFFFDF4)
                              .withOpacity(_isAgreeTermsCondition ? 1 : 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Adjust map pin",
                              style: TextStyle(
                                color: Color(0xFF2C2D2F),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            _isConfirmAddress = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: const Color(0XFFFFFDF4)
                              .withOpacity(_isAgreeTermsCondition ? 1 : 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: TextStyle(
                                color: Color(0xFF2C2D2F),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
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
                      // const SizedBox(height: 20),
                      const Text(
                        "Welcome! Let's get you started on your journey. Register your station to unlock a world of possibilities.",
                        style: TextStyle(fontSize: 16),
                      ),
                      // Image.asset('assets/images/Ayib.jpg',
                      //     width: imageWidth, height: 250),
                      const SizedBox(height: 15),
                      const Text(
                        "Station Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      _buildTextField(
                        controller: _stationNameController,
                        label: 'Station Name',
                        error: _errors['stationname'],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: (deviceWidth - 42) / 2,
                                child: _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  error: _errors['email'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: (deviceWidth - 42) / 2,
                                child: _buildTextField(
                                  controller: _addressController,
                                  label: 'Address',
                                  error: _errors['address'],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "State",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      isExpanded: true,
                                      padding: const EdgeInsets.only(left: 10),
                                      hint: const Text('Select State'),
                                      value: selectedState,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedState = newValue;
                                          _stateController.text = newValue!;
                                          lgas = states.firstWhere((state) =>
                                                  state['name'] == newValue)[
                                              'local_government_areas'];
                                          selectedLGA = null;
                                        });
                                      },
                                      items: states
                                          .map<DropdownMenuItem<String>>(
                                              (state) {
                                        return DropdownMenuItem<String>(
                                          value: state['name'],
                                          child: Text("${state['name']} State"),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "LGA",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      isExpanded: true,
                                      padding: const EdgeInsets.only(left: 10),
                                      hint: const Text(
                                        'Select LGA',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      value: selectedLGA,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedLGA = newValue;
                                          _lgaController.text = newValue!;
                                          // Find the selected LGA and set its latitude and longitude
                                          // final selectedLGAData =
                                          //     lgas.firstWhere((lga) =>
                                          //         lga['name'] == newValue);
                                          // lgaLatitude =
                                          //     selectedLGAData['latitude'];
                                          // lgaLongitude =
                                          //     selectedLGAData['longitude'];
                                        });
                                      },
                                      items: lgas
                                          .map<DropdownMenuItem<String>>((lga) {
                                        return DropdownMenuItem<String>(
                                          value: lga['name'],
                                          child: Text("${lga['name']} LGA"),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_isAgreeTermsCondition && !isLoading) {
                            _validateInputs();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          backgroundColor: const Color(0XFFECB920)
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
                              Navigator.of(context).popAndPushNamed(
                                  VendorSignin.routeName,
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
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.grey,
          ),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      onChanged: (text) {
        if (controller == _emailController) {
          controller.value = controller.value.copyWith(
            text: text.toLowerCase(),
            selection: TextSelection.collapsed(offset: text.length),
          );
        }
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
      _errors['stationname'] = _stationNameController.text.isEmpty
          ? 'Please enter your station full name'
          : null;
      _errors['address'] =
          _addressController.text.isEmpty ? 'Please enter your address' : null;
      // _errors['state'] =
      //     _stateController.text.isEmpty ? 'Please enter your state' : null;
      // _errors['lga'] =
      //     _lgaController.text.isEmpty ? 'Please enter your lga' : null;
      _errors['email'] = _addressController.text.isEmpty
          ? 'Please enter your email address'
          : null;
      _errors['phone'] = _phoneController.text.isEmpty
          ? 'Please enter your phone number'
          : null;
      _errors['password'] = _passwordController.text.isEmpty
          ? 'Please enter your password'
          : null;
    });

    if (_errors.values.every((error) => error == null)) {
      if (_isConfirmAddress) {
        handleSignUp();
      } else if (!_isConfirmAddress) {
        _showModalPopup();
      }
    }
  }

  @override
  void dispose() {
    _stationNameController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    _lgaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class MainWidget extends StatefulWidget {
  final Position? userLocation;
  final LatLng? stationCoordinate;
  final double width;
  final double height;
  final ValueChanged<PostalCodeInfo> getPostalCodeFunc;

  const MainWidget({
    super.key,
    required this.userLocation,
    required this.stationCoordinate,
    required this.height,
    required this.width,
    required this.getPostalCodeFunc,
  });

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late GoogleMapController mapController;
  final LatLng _nigeriaCoordinate = const LatLng(10.0, 8.0);
  final Map<String, Marker> _markers = {};
  bool markersAdded = false; // Flag to check if markers are added

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => _initializeMarkers());
  }

  @override
  void didUpdateWidget(MainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check when user location changes
    if (widget.userLocation != oldWidget.userLocation &&
        widget.userLocation?.latitude != null) {
      _addUserMarker();
    }
  }

  Future<void> _initializeMarkers() async {
    // Ensure markers are only added once
    if (!markersAdded && widget.userLocation?.latitude != null) {
      if (widget.userLocation?.latitude != null) {
        // _addUserMarker();
      }

      markersAdded = true; // Mark as added after setting markers
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    // print(
    //     "lat: ${widget.userLocation?.latitude}, long: ${widget.userLocation?.longitude}");
    // Ensure markers are added once the map is created
    if (widget.userLocation?.latitude != null) {
      _addUserMarker();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     "lat: ${widget.userLocation?.latitude}, long: ${widget.userLocation?.longitude}");

    return GestureDetector(
      onTap: () {
        setState(() {
          //
        });
      },
      onDoubleTap: () {
        setState(() {
          //
        });
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.orange[600],
        child: StatefulBuilder(
          builder: (context, setState) {
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _nigeriaCoordinate,
                zoom: 15.0,
              ),
              markers: _markers.values.toSet(),
              onTap: (LatLng coordinates) async {
                List<Placemark> placemarks = await placemarkFromCoordinates(
                    coordinates.latitude, coordinates.longitude);
                Placemark place = placemarks[0];
                widget.getPostalCodeFunc(PostalCodeInfo(
                  postalCode: int.parse(place.postalCode.toString()),
                  latitude: coordinates.latitude.toString(),
                  longitude: coordinates.longitude.toString(),
                  googleLga: place.subAdministrativeArea.toString(),
                ));

                setState(() {
                  // Remove the old marker and add a new one with the updated position
                  if (_markers.isNotEmpty) {
                    // Assume you are updating the first marker in the map
                    String markerId = _markers.keys.first;

                    Marker updatedMarker = Marker(
                      markerId: MarkerId(markerId),
                      position: coordinates, // New position
                      infoWindow: InfoWindow(
                        title: 'New Location',
                        snippet:
                            'Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}',
                      ),
                      icon: BitmapDescriptor.defaultMarker,
                    );

                    // Update the map with the new marker
                    _markers[markerId] = updatedMarker;
                  }
                });

                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                      LatLng(coordinates.latitude, coordinates.longitude),
                      15.0),
                );
                print(
                    "The tapped Latitude: ${coordinates.latitude}, Longitude: ${coordinates.longitude}");
              },
            );
          },
        ),
      ),
    );
  }

  void _addUserMarker() {
    if (/*widget.userLocation?.latitude != null*/ widget
            .stationCoordinate?.latitude !=
        0) {
      LatLng userLocation = LatLng(widget.stationCoordinate!.latitude,
          widget.stationCoordinate!.longitude);
      Marker userMarker = Marker(
        markerId: MarkerId(
            widget.userLocation.toString()), // Use userLocation for markerId
        position: userLocation,
        infoWindow: InfoWindow(
          title: 'Your Location',
          snippet:
              'Latitude: ${widget.stationCoordinate!.latitude}, Longitude: ${widget.stationCoordinate!.longitude}',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      setState(() {
        _markers[widget.stationCoordinate.toString()] = userMarker;

        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(widget.stationCoordinate!.latitude,
                widget.stationCoordinate!.longitude),
            15.0,
          ),
        );
      });

      // print(
      //     "latitude: ${widget.userLocation?.latitude}, longitude: ${widget.userLocation?.longitude}, markers: ${_markers.length}");
    }
  }
}
