import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/API/helpers.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Main/search.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/all_near_fuel_stations.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/directions.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/on_tapped_station.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

String? googleMapsApiKey = dotenv.env['GOOGLE_MAP_API_KEY'];

class MainHome extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;
  final ValueChanged<bool> onShowNavBarChanged;

  const MainHome({
    super.key,
    required this.onIndexChanged,
    required this.onShowNavBarChanged,
  });

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  Position? _currentPosition;
  Placemark? _userPlace;
  bool? _hasPermission;
  // String? _address;
  int _homeIndex = 0;
  bool? isLoading;
  var tappedStation;

  void _updateHomeIndex(int newIndex) {
    setState(() {
      if (newIndex >= 1 && newIndex < 3) {
        widget.onShowNavBarChanged(false);
      } else {
        widget.onShowNavBarChanged(true);
      }

      if (newIndex == 3) {
        widget.onIndexChanged(1);
      }
      _homeIndex = newIndex;
    });
  }

  void _updateTappedStation(var station) {
    setState(() {
      tappedStation = station;
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

    if (permissionGranted != null) {
      setState(() {
        _hasPermission = permissionGranted;
      });
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
        // _address = address;
        _userPlace = place;
      });

      String state = "";
      // place.locality!;
      if (state.isEmpty) {
        var stateSplitted = place.administrativeArea!.split(' ');
        state = stateSplitted[0];
      }
      GetAllVendorsPayload payload = GetAllVendorsPayload(
        userid: store.state.user['id'],
        state: state,
        lga: place.subAdministrativeArea!.replaceAll("/", "-"),
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
      );

      handleGetAllVendors(payload);
    }
  }

  Future<void> _fetchLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Request location service
      serviceEnabled = await Geolocator.openLocationSettings();
      if (!serviceEnabled) {
        return; // Exit if the service is still not enabled
      }
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return; // Exit if permission is denied
      }
    }

    // Start listening for location changes
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position? position) {
      if (position != null) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
  }

  Future<void> handleGetAllVendors(GetAllVendorsPayload payload) async {
    setState(() {
      isLoading = true;
    });

    try {
      // print("payload: $userPayload");
      Tuple2<int, String> result = await getAllVendors(payload);

      if (result.item1 == 1) {
        if (mounted) {
          myNotificationBar(context, result.item2, "success");
        }

        // You might want to navigate to another screen or perform user registration
      } else {
        // Failed sign-up
        if (mounted) {
          myNotificationBar(context, result.item2, "error");
        }
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Close the keyboard when this screen is built
    FocusScope.of(context).unfocus();

    // double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.07;

    // if (_hasPermission == true && _currentPosition != null) {
    //   print("current position: $_userPlace");
    // }

    return StoreConnector<AppState, dynamic>(
        converter: (store) => store, //store.state.user
        builder: (context, state /*user*/) {
          var fname = store.state.user['firstname'];
          var imageUrl = store.state.user['imageurl'];
          String commuterImage =
              "https://drive.google.com/thumbnail?id=$imageUrl";
          var allvendors = store.state.allVendors;
          return Stack(
            children: [
              MainWidget(
                onIndexChangedFunc: _updateHomeIndex,
                allvendors: allvendors,
                userPlace: _userPlace,
                userLocation: _currentPosition,
              ),
              if (_homeIndex == 0)
                Positioned(
                  top: 0, //mtop,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello $fname",
                              style: const TextStyle(
                                  color: Color(0xFF2C2D2F),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Color(0xFFA9E27C),
                                  size: 10,
                                ),
                                const SizedBox(width: 10),
                                if (_hasPermission == true &&
                                    _currentPosition == null)
                                  const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1,
                                    ),
                                  ),
                                if (_hasPermission == true &&
                                    _currentPosition != null)
                                  Text(
                                    _userPlace != null
                                        ? _userPlace!.subAdministrativeArea!
                                        : "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Color(0xFF2C2D2F),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            widget.onIndexChanged(3);
                          },
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: imageUrl == null || imageUrl == ""
                                ? const AssetImage('assets/images/commuter.png')
                                : NetworkImage(commuterImage) as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_homeIndex != 0)
                Positioned(
                  top: mtop * 0.3,
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
              // const Spacer(),
              _homeIndex == 0
                  ? AllNearFuelStations(
                      onIndexChangedFunc: _updateHomeIndex,
                      onTappedChangedFunc: _updateTappedStation,
                    )
                  : _homeIndex == 1
                      ? OnTappedStation(
                          stationName: capitalize(tappedStation['stationname']),
                          location:
                              "${capitalize(tappedStation['address'])} ${tappedStation['lga']} ${tappedStation['state']}",
                          phone: tappedStation['phonenumber'],
                          estimatedTime: '8 mins',
                          distance: '2 km',
                          icon: Icons.access_time_outlined,
                          isFuelAvailable: true,
                          onIndexChangedFunc: _updateHomeIndex,
                          vendor: tappedStation,
                        )
                      : Directions(
                          onIndexChangedFunc: _updateHomeIndex,
                          stationname: capitalize(tappedStation['stationname']),
                        ),
            ],
          );
        });
  }
}

class MainWidget extends StatefulWidget {
  final ValueChanged<int> onIndexChangedFunc;
  final List<dynamic> allvendors;
  final Position? userLocation;
  final Placemark? userPlace;

  const MainWidget({
    super.key,
    required this.onIndexChangedFunc,
    required this.allvendors,
    required this.userLocation,
    required this.userPlace,
  });

  @override
  State<MainWidget> createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  late GoogleMapController mapController;
  final LatLng _nigeriaCoordinate = const LatLng(10.0, 8.0);
  final Map<String, Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};
  bool markersAdded = false; // Flag to check if markers are added
  bool isLocationChanged = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) async => _initializeMarkers());
  }

  @override
  void didUpdateWidget(MainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if allvendors list has changed
    if (widget.allvendors != oldWidget.allvendors &&
        widget.allvendors.isNotEmpty) {
      List<Vendor> vendors = parseVendors(widget.allvendors);
      _addVendorsMarkers(vendors); // Update markers
      setState(() {
        isLocationChanged = true;
      });
    }

    //Check when user location change
    if (widget.userLocation != oldWidget.userLocation &&
        widget.userLocation?.latitude != null) {
      // print("user location changed");
      _addUserMarker();
    }

    if (widget.allvendors.isNotEmpty && widget.userLocation?.latitude != null) {
      print(
          "Calling polyline function: ${widget.userLocation?.latitude}, ${widget.allvendors[0]['latitude']}");
      _drawDirectionPolyLines();
    }
  }

  Future<void> _initializeMarkers() async {
    // Ensure markers are only added once
    if (!markersAdded) {
      if (widget.userLocation?.latitude != null) {
        // _addUserMarker();
      }

      if (widget.allvendors.isNotEmpty) {
        List<Vendor> vendors = parseVendors(widget.allvendors);
        _addVendorsMarkers(vendors);
      }

      markersAdded = true; // Mark as added after setting markers
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _addUserMarker();

    // Ensure markers are added once the map is created
    if (widget.allvendors.isNotEmpty) {
      List<Vendor> vendors = parseVendors(widget.allvendors);
      _addVendorsMarkers(vendors);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.onIndexChangedFunc(0);
        });
      },
      onDoubleTap: () {
        setState(() {
          widget.onIndexChangedFunc(0);
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.orange[600],
        child: StatefulBuilder(
          builder: (context, setState) {
            return GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _nigeriaCoordinate,
                zoom: widget.allvendors.isEmpty ? 7.5 : 15.0,
              ),
              markers: _markers.values.toSet(),
              polylines: Set<Polyline>.of(polylines.values),
              onTap: (argument) {
                print(
                    "The tapped Latitude: ${argument.latitude}, Longitude: ${argument.longitude}");
              },
            );
          },
        ),
      ),
    );
  }

  void _addUserMarker() {
    // print("check: ${widget.userLocation?.latitude}");
    if (widget.userLocation?.latitude != null) {
      LatLng userLocation =
          LatLng(widget.userLocation!.latitude, widget.userLocation!.longitude);
      Marker userMarker = Marker(
        markerId: MarkerId(store.state.user['id'].toString()),
        position: userLocation,
        infoWindow: InfoWindow(
          title: store.state.user['firstname'],
          snippet:
              "${widget.userPlace!.street} ${widget.userPlace!.locality} state",
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      setState(() {
        _markers[store.state.user['id'].toString()] = userMarker;
      });
    }
  }

  void _addVendorsMarkers(List<Vendor> vendors) async {
    Map<String, Marker> newMarkers = {};

    for (var vendor in vendors) {
      LatLng vendorLocation = LatLng(vendor.latitude, vendor.longitude);
      var markerIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(25.0, 30.0)),
        vendor.isDiesel || vendor.isGas || vendor.isPetrol
            ? 'assets/images/green_station.png'
            : 'assets/images/red_station.png',
      );
      Marker marker = Marker(
        markerId: MarkerId(vendor.id.toString()),
        position: vendorLocation,
        infoWindow: InfoWindow(
          title: vendor.stationName,
          snippet: "${vendor.address} ${vendor.lga} ${vendor.state}",
        ),
        icon: markerIcon,
      );
      newMarkers[vendor.id.toString()] = marker;
    }

    setState(() {
      _markers.addAll(newMarkers); // Update the markers on the map.

      mapController.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(vendors[0].latitude, vendors[0].longitude), 15.0),
      );
    });
  }

  void _drawDirectionPolyLines() async {
    // print("about to call _fetchPolylinePoints function");
    List<LatLng> polylinePoints = await _fetchPolylinePoints();
    if (polylinePoints.isNotEmpty) {
      // print("about to call _generatePolyLineFromPoints function");
      await _generatePolyLineFromPoints(polylinePoints);
    }
  }

  Future<List<LatLng>> _fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleMapsApiKey,
        request: PolylineRequest(
          mode: TravelMode.driving,
          origin: PointLatLng(
            widget.userLocation!.latitude,
            widget.userLocation!.longitude,
          ),
          destination: PointLatLng(
            double.parse(widget.allvendors[0]['latitude']),
            double.parse(widget.allvendors[0]['longitude']),
          ),
        ));

    LatLng origin = LatLng(
      widget.userLocation!.latitude,
      widget.userLocation!.longitude,
    );

    LatLng destination = LatLng(
      double.parse(widget.allvendors[0]['latitude']),
      double.parse(widget.allvendors[0]['longitude']),
    );

// Fetch travel details using the origin and destination
    final travelDetails = await fetchTravelDetails(origin, destination);
    print('Distance: ${travelDetails['distance']}');
    print('Duration: ${travelDetails['duration']}');

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }

  Future<void> _generatePolyLineFromPoints(
      List<LatLng> polylineCoordinates) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }
}
