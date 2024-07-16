import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(25.1193, 55.3773);

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

    Placemark place = placemarks[0];
    String address =
        "${place.street} ${place.locality} state ${place.country}, postal code ${place.postalCode}";

    //print("Placemarks: " + placemarks.toString());

    setState(() {
      _currentPosition = position;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.45;

    return Scaffold(
      body: Stack(
        children: [
          MainWidget(),
          Positioned.fill(
            child: DraggableScrollableSheet(
              initialChildSize: 0.4, // Initial size of widget A
              minChildSize: 0.4, // Minimum size of widget A
              maxChildSize: 0.7, // Maximum size of widget A
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Stack(
                  children: [
                    ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(0),
                      children: <Widget>[
                        Container(
                          height: 1000, // Example height to allow scrolling
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 25),
                                const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text(
                                    'Fuel Stations Near you',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 17),
                                Container(
                                  alignment: Alignment.center,
                                  // padding: const EdgeInsets.symmetric(
                                  //   horizontal: 8.0,
                                  // ),
                                  height: 70,
                                  decoration: const BoxDecoration(
                                    color: Colors.grey,
                                    // border: Border.all(
                                    //   color: Colors.black,
                                    //   width: 2,
                                    // ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "EST. TIME",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "2 km",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.access_time_outlined,
                                                size: 16,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "8 mins away",
                                                style: TextStyle(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 20,
                                        width: 2,
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
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Oando Fuel Station",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Text(
                                            "Eti-Osa, Lagos, Nigeria",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pushReplacementNamed(
                                              context,
                                              CommuterSignup.routeName);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(24, 24),
                                          backgroundColor:
                                              const Color(0xFFD9D9D9),
                                          shape: const CircleBorder(),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const RotatedBox(
                                          quarterTurns: 2,
                                          child: Icon(
                                            Icons.subdirectory_arrow_left,
                                            color: Color(0xFF9A9898),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Draggable Indicator
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          height: 5,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.86, 151.20);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    addMarker("Sydney", currentLocation);
  }

  Map<String, Marker> _makers = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[600],
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _makers.values.toSet(),
      ),
    );
  }

  addMarker(String id, LatLng location) async {
    var markerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(), 'assets/icons/book_icon.png');
    var maker = Marker(
      markerId: MarkerId(id),
      position: location,
      infoWindow: const InfoWindow(
        title: "Place title",
        snippet: "place description",
      ),
      icon: markerIcon,
    );

    setState(() {
      _makers[id] = maker;
    });
  }
}
