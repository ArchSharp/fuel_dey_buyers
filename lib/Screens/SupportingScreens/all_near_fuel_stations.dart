import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/near_station.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AllNearFuelStations extends StatefulWidget {
  final ValueChanged<int> onIndexChangedFunc;
  final ValueChanged<Vendor> onTappedChangedFunc;
  final Position? userCoordinates;
  final String noVendorsMessage;

  const AllNearFuelStations({
    super.key,
    required this.onIndexChangedFunc,
    required this.onTappedChangedFunc,
    required this.userCoordinates,
    required this.noVendorsMessage,
  });

  @override
  State<AllNearFuelStations> createState() => _AllNearFuelStationsState();
}

class _AllNearFuelStationsState extends State<AllNearFuelStations> {
  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();
  final ValueNotifier<double> _heightPercentageNotifier =
      ValueNotifier<double>(0.5);

  @override
  void initState() {
    super.initState();
    _scrollableController.addListener(() {
      _heightPercentageNotifier.value = _scrollableController.size;
    });
  }

  @override
  void dispose() {
    _scrollableController.removeListener(() {});
    _scrollableController.dispose();
    _heightPercentageNotifier.dispose();
    super.dispose();
  }

  changedTappedStation(Vendor station) {
    widget.onTappedChangedFunc(station);
  }

  Future<List<Widget>> fetchNearStations(List<Vendor> allVendors) async {
    return await Future.wait(allVendors.map((vendor) async {
      LatLng origin = LatLng(
          widget.userCoordinates!.latitude, widget.userCoordinates!.longitude);
      LatLng destination = LatLng(vendor.latitude, vendor.longitude);

      print(
          'origin: ${origin.latitude} destination ${vendor.latitude} id: ${vendor.id}');
      // Fetch travel details using the origin and destination
      final travelDetails = await fetchTravelDetails(origin, destination);

      String? estimatedTime = travelDetails.time;
      String? distance = travelDetails.distance;
      print('Near Station Distance: $distance');
      print('Near Station Duration: $estimatedTime');

      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: NearStation(
          estimatedTime: estimatedTime,
          distance: distance,
          onIndexChanged: widget.onIndexChangedFunc,
          vendor: vendor,
          onTappedChanged: (station) => changedTappedStation(station),
        ),
      );
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double initialHeight = 0.3;
    double minHeight = 0.3;
    double maxHeight = 0.6;

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store, //store.state.user
      builder: (context, store) {
        var allVendors = store.state.allVendors;
        allVendors.sort((a, b) {
          // Prioritize vendors with diesel
          if (a.isDiesel == true && b.isDiesel != true) {
            return -1;
          } else if (a.isDiesel != true && b.isDiesel == true) {
            return 1;
          }

          // If diesel is the same, prioritize vendors with gas
          if (a.isGas == true && b.isGas != true) {
            return -1;
          } else if (a.isGas != true && b.isGas == true) {
            return 1;
          }

          // If diesel and gas are the same, prioritize vendors with petrol
          if (a.isPetrol == true && b.isPetrol != true) {
            return -1;
          } else if (a.isPetrol != true && b.isPetrol == true) {
            return 1;
          }

          // If all conditions are the same, keep the order
          return 0;
        });

        return FutureBuilder<List<Widget>>(
          future: fetchNearStations(allVendors),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else if (snapshot.hasError) {
            //   return const Center(
            //     child: Text('Error fetching stations'),
            //   );
            // }

            List<Widget>? nearStations = snapshot.data;

            return Positioned.fill(
              child: DraggableScrollableSheet(
                controller: _scrollableController,
                initialChildSize: initialHeight,
                minChildSize: minHeight,
                maxChildSize: maxHeight,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return ValueListenableBuilder<double>(
                    valueListenable: _heightPercentageNotifier,
                    builder: (context, height, child) {
                      return Stack(
                        children: [
                          Container(
                            height: maxHeight * deviceHeight,
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 25),
                                  const Text(
                                    'Fuel Stations Near you',
                                    style: TextStyle(
                                      color: Color(0xFF2C2D2F),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 17),
                                  if (allVendors.isNotEmpty) ...?nearStations,
                                  if (allVendors.isEmpty &&
                                      widget.noVendorsMessage == "")
                                    const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Fetching Stations..."),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  if (allVendors.isEmpty &&
                                      widget.noVendorsMessage != "")
                                    Center(
                                      child: Text(
                                        widget.noVendorsMessage,
                                        style: const TextStyle(
                                          color: Color(0xFF2C2D2F),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4E4E4E),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
