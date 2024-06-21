import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static const routeName = '/home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position? _currentPosition;
  bool? _hasPermission;
  String? _address;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? permissionGranted = prefs.getBool('location_permission_granted');

    if (permissionGranted == null) {
      // First time asking for permission
      _showPermissionDialog();
    } else {
      setState(() {
        _hasPermission = permissionGranted;
      });
      if (permissionGranted) {
        _getCurrentLocation();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Center(
          child: Text('Allow Location Access', style: TextStyle(fontSize: 14)),
        ),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Do you want to allow location access? Allowing access will help us give you real-time, high quality services such as filling station with good litre measurement, ',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => _onPermissionGranted(),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => _onPermissionDenied(),
                child: const Text('No'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onPermissionDenied() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_permission_granted', false);
    setState(() {
      _hasPermission = false;
    });
    Navigator.of(context).pop();
  }

  void _onPermissionGranted() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    bool isGranted = permissionStatus == PermissionStatus.granted;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('location_permission_granted', isGranted);

    setState(() {
      _hasPermission = isGranted;
    });

    Navigator.of(context).pop();

    if (isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    String address =
        "${placemarks[0].street} ${placemarks[0].locality} state ${placemarks[0].country}, postal code ${placemarks[0].postalCode} ";

    //print("Placemarks: " + placemarks.toString());

    setState(() {
      _currentPosition = position;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.45;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                SizedBox(height: mtop),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Welcome to Fuel Dey",
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_hasPermission == true && _currentPosition == null)
                  const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                if (_hasPermission == true && _currentPosition == null)
                  const Text("Fetching location..."),
                if (_hasPermission == true && _currentPosition != null)
                  Row(
                    children: [
                      const Text(
                        "Latitude: ",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 16),
                      ),
                      Text("${_currentPosition?.latitude}"),
                    ],
                  ),
                if (_hasPermission == true && _currentPosition != null)
                  Row(
                    children: [
                      const Text(
                        "Longitude: ",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 16),
                      ),
                      Text("${_currentPosition?.longitude}"),
                    ],
                  ),
                if (_hasPermission == true && _currentPosition != null)
                  Row(
                    children: [
                      const Text(
                        "Address: ",
                        style:
                            TextStyle(color: Colors.deepOrange, fontSize: 16),
                      ),
                      Flexible(
                        child: Text(
                          _address!,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.visible,
                          softWrap: true,
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
}
