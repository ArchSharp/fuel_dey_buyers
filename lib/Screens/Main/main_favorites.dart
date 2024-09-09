import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/favorites.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng currentLocation = LatLng(25.1193, 55.3773);

class MainFavorites extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const MainFavorites({
    super.key,
    required this.onIndexChanged,
  });
  static const routeName = '/main_favorites';

  @override
  State<MainFavorites> createState() => _MainFavoritesState();
}

class _MainFavoritesState extends State<MainFavorites> {
  @override
  Widget build(BuildContext context) {
    // double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.07;

    return Stack(
      children: [
        MainWidget(onIndexChanged: widget.onIndexChanged),
        Positioned(
          top: mtop * 0.5,
          left: 20,
          // right: 20,
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFF018D5C),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              iconSize: 20,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                widget.onIndexChanged(0);
              },
            ),
          ),
        ),
        const Favorites(),
      ],
    );
  }
}

class MainWidget extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const MainWidget({
    super.key,
    required this.onIndexChanged,
  });

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

  final Map<String, Marker> _makers = {};

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Map is tapped");
        setState(() {
          widget.onIndexChanged(1);
        });
      },
      onDoubleTap: () {
        setState(() {
          print("Map is double tapped");
          setState(() {
            widget.onIndexChanged(0);
          });
        });
      },
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.orange[600],
          child: const Center(
            child: Text("Map is here"),
          )
          // GoogleMap(
          //   onMapCreated: _onMapCreated,
          //   initialCameraPosition: CameraPosition(
          //     target: _center,
          //     zoom: 11.0,
          //   ),
          //   markers: _makers.values.toSet(),
          // ),
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
