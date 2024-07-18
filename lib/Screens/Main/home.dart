import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/Main/search.dart';
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
              initialChildSize:
                  _homeIndex == 0 ? 0.3 : 0.5, // Initial size of widget A
              minChildSize:
                  _homeIndex == 0 ? 0.3 : 0.5, // Minimum size of widget A
              maxChildSize:
                  _homeIndex == 0 ? 0.7 : 0.5, // Maximum size of widget A
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
                                  ? OnTappedStation(
                                      stationName: 'Oando Fuel Station',
                                      location: 'Eti-Osa, Lagos, Nigeria',
                                      estimatedTime: '8 mins',
                                      distance: '2 km',
                                      icon: Icons.access_time_outlined,
                                      isFuelAvailable: true,
                                      onIndexChanged: _updateHomeIndex,
                                    )
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

class Directions extends StatelessWidget {
  final ValueChanged<int> onIndexChanged;

  const Directions({
    super.key,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Directions",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFF2C2D2F),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            iconSize: 16,
                            onPressed: () {},
                            icon: const Icon(Icons.directions_car),
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          width: 40,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: const Color(0xFF2C2D2F),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            padding: const EdgeInsets.all(0),
                            iconSize: 16,
                            onPressed: () {},
                            icon: const Icon(Icons.directions_walk),
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2D2F),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 16,
                    onPressed: () {
                      onIndexChanged(1);
                    },
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: '8 min',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: ' (1 km)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  "Best route",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2D2F),
                    shape: BoxShape.circle,
                  ),
                  child: Transform.rotate(
                    angle: 50 * (3.141592653589793 / 180),
                    child: const Icon(
                      Icons.navigation_outlined,
                      color: Color(0xFFC9C9C9),
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.black,
                ),
                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.black,
                ),
                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2D2F),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 16,
                    onPressed: () {
                      onIndexChanged(1);
                    },
                    icon: const Icon(Icons.place),
                    color: const Color(0xFFC9C9C9),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.black,
                ),
                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.black,
                ),
                const Icon(
                  Icons.circle,
                  size: 4,
                  color: Colors.black,
                ),
                const SizedBox(height: 8),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2D2F),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    iconSize: 16,
                    onPressed: () {
                      onIndexChanged(1);
                    },
                    icon: const Icon(Icons.add),
                    color: const Color(0xFFC9C9C9),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AllNearFuelStations extends StatelessWidget {
  const AllNearFuelStations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.all(0),
              child: Text(
                'Fuel Stations Near you',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 17),
            NearStation(
              stationName: 'Oando Fuel Station',
              location: 'Eti-Osa, Lagos, Nigeria',
              estimatedTime: '8 mins away',
              distance: '2 km',
              icon: Icons.access_time_outlined,
              isFuelAvailable: true,
            ),
            SizedBox(height: 15),
            NearStation(
              stationName: 'Mobil Fuel Station',
              location: 'Apapa, Lagos, Nigeria',
              estimatedTime: '24 mins away',
              distance: '6 km',
              icon: Icons.access_time_outlined,
              isFuelAvailable: false,
            ),
          ],
        ),
      ),
    );
  }
}

class OnTappedStation extends StatelessWidget {
  final String stationName;
  final String location;
  final String estimatedTime;
  final String distance;
  final IconData icon;
  final bool isFuelAvailable;
  final ValueChanged<int> onIndexChanged;

  const OnTappedStation({
    super.key,
    required this.stationName,
    required this.location,
    required this.estimatedTime,
    required this.distance,
    required this.icon,
    required this.isFuelAvailable,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width - 32;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2,
              // ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize : MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle, // or Icons.brightness_1
                          size: 10.0, // You can adjust the size as needed
                          color: Colors
                              .black, // You can change the color as needed
                        ),
                        const SizedBox(width: 10),
                        Text(
                          stationName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Oando Fuel Station',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2D2F),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 14,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.ios_share_outlined,
                      color: Color(0xFFC1C1C1),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/commuter_signup');
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2C2D2F),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    iconSize: 14,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.favorite_outline_outlined,
                      color: Color(0xFFC1C1C1),
                    ),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, '/commuter_signup');
                    },
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2,
              // ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Distance",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      distance,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      estimatedTime,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2,
              // ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.location_on_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/commuter_signup');
                  },
                ),
                Text(
                  location,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2,
              // ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.local_gas_station_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/commuter_signup');
                  },
                ),
                const Text(
                  "Fuel Type Available:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2,
              // ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, CommuterSignup.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(69, 32),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Petrol",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, CommuterSignup.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(69, 32),
                    backgroundColor: const Color(0xFFC1C1C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Gas",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, CommuterSignup.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(69, 32),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    "Diesel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.black,
              //   width: 2,
              // ),
            ),
            child: ElevatedButton(
              onPressed: () {
                onIndexChanged(2);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: const Color(0xFF2C2D2F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Navigate",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Transform.rotate(
                    angle: 50 * (3.141592653589793 / 180),
                    child: const Icon(
                      Icons.navigation_outlined,
                      color: Color(0xFFC9C9C9),
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NearStation extends StatelessWidget {
  final String stationName;
  final String location;
  final String estimatedTime;
  final String distance;
  final IconData icon;
  final bool isFuelAvailable;

  const NearStation({
    super.key,
    required this.stationName,
    required this.location,
    required this.estimatedTime,
    required this.distance,
    required this.icon,
    required this.isFuelAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 8.0,
      // ),
      height: 70,
      decoration: BoxDecoration(
        color: isFuelAvailable ? const Color(0xFFC9C9C9) : Colors.grey[600],
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2,
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "EST. TIME",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                distance,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    size: 16,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    estimatedTime,
                    style: const TextStyle(
                      fontSize: 10,
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                stationName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // const Spacer(),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 14,
              padding: EdgeInsets.zero,
              icon: const RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.subdirectory_arrow_left,
                  color: Color(0xFF9A9898),
                  size: 20,
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, CommuterSignup.routeName);
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
