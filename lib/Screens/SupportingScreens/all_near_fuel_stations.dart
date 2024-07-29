import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/near_station.dart';

class AllNearFuelStations extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const AllNearFuelStations({
    super.key,
    required this.onIndexChanged,
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

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    double initialHeight = 0.3;
    double minHeight = 0.3;
    double maxHeight = 0.6;

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
                          NearStation(
                            stationName: 'Oando Fuel Station',
                            location: 'Eti-Osa, Lagos, Nigeria',
                            estimatedTime: '8 mins away',
                            distance: '2 km',
                            icon: Icons.access_time_outlined,
                            isFuelAvailable: true,
                            onIndexChanged: widget.onIndexChanged,
                          ),
                          const SizedBox(height: 15),
                          NearStation(
                            stationName: 'Mobil Fuel Station',
                            location: 'Apapa, Lagos, Nigeria',
                            estimatedTime: '24 mins away',
                            distance: '6 km',
                            icon: Icons.access_time_outlined,
                            isFuelAvailable: false,
                            onIndexChanged: widget.onIndexChanged,
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
                          borderRadius: BorderRadius.all(Radius.circular(100)),
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
  }
}
