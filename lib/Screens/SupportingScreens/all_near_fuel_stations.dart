import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/API/helpers.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/near_station.dart';

class AllNearFuelStations extends StatefulWidget {
  final ValueChanged<int> onIndexChangedFunc;
  final ValueChanged<dynamic> onTappedChangedFunc;

  const AllNearFuelStations({
    super.key,
    required this.onIndexChangedFunc,
    required this.onTappedChangedFunc,
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

  changedTappedStation(var station) {
    widget.onTappedChangedFunc(station);
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    double initialHeight = 0.3;
    double minHeight = 0.3;
    double maxHeight = 0.6;

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store, //store.state.user
      builder: (context, state /*user*/) {
        var allVendors = store.state.allVendors;

        List<Widget>? nearStations = [];
        if (allVendors.isNotEmpty) {
          nearStations = allVendors.map((vendor) {
            var stationname = capitalize(vendor['stationname']);
            var location =
                "${capitalize(vendor['address'])} ${vendor['lga']} ${vendor['state']}";
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: NearStation(
                stationName: stationname,
                location: location,
                estimatedTime: '8 mins away', // Update this as needed
                distance: '2 km', // Update this as needed
                icon: Icons.access_time_outlined,
                isFuelAvailable: true, // Update this as needed
                onIndexChanged: widget.onIndexChangedFunc,
                vendor: vendor,
                onTappedChanged: (station) => changedTappedStation(station),
              ),
            );
          }).toList();
        }
        return Positioned.fill(
          child: DraggableScrollableSheet(
            controller: _scrollableController,
            initialChildSize: initialHeight,
            minChildSize: minHeight,
            maxChildSize: maxHeight,
            builder: (BuildContext context, ScrollController scrollController) {
              return ValueListenableBuilder<double>(
                valueListenable: _heightPercentageNotifier,
                builder: (context, height, child) {
                  return Stack(
                    children: [
                      Container(
                        height: maxHeight * deviceHeight,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                              if (allVendors.isNotEmpty) ...nearStations!,
                              if (allVendors.isEmpty)
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                )
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
  }
}
