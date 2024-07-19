import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/near_station.dart';

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
