import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/Main/search.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/all_near_fuel_stations.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/directions.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/on_tapped_station.dart';
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
  int _homeIndex = 1;

  void _updateHomeIndex(int newIndex) {
    setState(() {
      _homeIndex = newIndex;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  // final _searchFocusNode = FocusNode();
  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();
  final ValueNotifier<double> _heightPercentageNotifier =
      ValueNotifier<double>(0.3);

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _scrollableController.addListener(() {
      _heightPercentageNotifier.value = _scrollableController.size;
      // _searchController.text = _scrollableController.size.toString();
    });
  }
// {print(_heightPercentageNotifier.value);}

  @override
  void dispose() {
    _scrollableController.removeListener(() {});
    _scrollableController.dispose();
    _heightPercentageNotifier.dispose();
    super.dispose();
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
    FocusScope.of(context)
        .unfocus(); // Close the keyboard when this screen is built

    // double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.07;

    return Scaffold(
      body: Stack(
        children: [
          const MainWidget(),
          Positioned(
            top: mtop,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,

                // focusNode: _searchFocusNode,
                onTap: () {
                  Navigator.of(context).pushNamed(Search.routeName,
                      arguments: 'Passing data from SignIn');
                },
                decoration: InputDecoration(
                  hintText: 'e.g Oando...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DraggableScrollableSheet(
              controller: _scrollableController,
              initialChildSize:
                  _homeIndex == 0 ? 0.3 : 0.5, // Initial size of widget A
              minChildSize:
                  _homeIndex == 0 ? 0.3 : 0.5, // Minimum size of widget A
              maxChildSize: _homeIndex == 0
                  ? 0.7
                  : _homeIndex == 1
                      ? 0.8
                      : 0.5, // Maximum size of widget A
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Stack(
                  children: [
                    ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(0),
                      children: <Widget>[
                        Container(
                          height: _homeIndex == 0
                              ? deviceHeight * 0.7
                              : _homeIndex == 1
                                  ? 0.8 * deviceHeight
                                  : deviceHeight *
                                      0.5, // Example height to allow scrolling
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              )),
                          child: _homeIndex == 0
                              ? const AllNearFuelStations()
                              : _homeIndex == 1
                                  ? ValueListenableBuilder<double>(
                                      valueListenable:
                                          _heightPercentageNotifier,
                                      builder: (context, height, child) {
                                        return OnTappedStation(
                                          stationName: 'Oando Fuel Station',
                                          location: 'Eti-Osa, Lagos, Nigeria',
                                          estimatedTime: '8 mins',
                                          distance: '2 km',
                                          icon: Icons.access_time_outlined,
                                          isFuelAvailable: true,
                                          onIndexChanged: _updateHomeIndex,
                                          currentScrolHeight: height,
                                        );
                                      })
                                  : Directions(
                                      onIndexChanged: _updateHomeIndex,
                                    ),
                        ),
                      ],
                    ),
                    // Draggable Indicator
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: ValueListenableBuilder<double>(
                          valueListenable: _heightPercentageNotifier,
                          builder: (context, value, child) {
                            return Center(
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
                            );
                          }),
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
  const MainWidget({super.key});

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
