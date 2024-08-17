import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/helpers.dart';

class NearStation extends StatefulWidget {
  final String estimatedTime;
  final String distance;
  final ValueChanged<int> onIndexChanged;
  final Function(dynamic) onTappedChanged;
  final dynamic vendor;

  const NearStation({
    super.key,
    required this.estimatedTime,
    required this.distance,
    required this.onIndexChanged,
    required this.onTappedChanged,
    required this.vendor,
  });

  @override
  State<NearStation> createState() => _NearStationState();
}

class _NearStationState extends State<NearStation> {
  bool isFuelAvailable = false;
  String station_address = "";

  @override
  void initState() {
    super.initState();
    var vendor = widget.vendor;
    if (vendor['isdiesel'] == true ||
        vendor['isgas'] == true ||
        vendor['ispetrol'] == true) {
      isFuelAvailable = true;
    }

    // if("${capitalize(vendor['address'])} ${vendor['lga']} ${vendor['state']}".length>18){
    //   station_address= "${station_address.substring(0,18)}...";
  }

  @override
  Widget build(BuildContext context) {
    station_address =
        "${capitalize(widget.vendor['address'])} ${widget.vendor['lga']} ${widget.vendor['state']}";

    if (station_address.length > 23) {
      station_address = "${station_address.substring(0, 23)}...";
    }

    return Container(
      alignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(
      //   horizontal: 8.0,
      // ),
      height: 70,
      decoration: BoxDecoration(
        color: isFuelAvailable
            ? const Color(0xFF018D5C)
            : const Color(0xFF018D5C).withOpacity(0.5),
        // border: Border.all(
        //   color: Colors.black,
        //   width: 2,
        // ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "EST. TIME",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.distance,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.access_time_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      widget.estimatedTime,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            width: 2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFFDF4),
                  Color(0xFFFFFDF4),
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
                capitalize(widget.vendor['stationname']),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Text(
                station_address,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  alignment: Alignment.center,
                  iconSize: 14,
                  padding: EdgeInsets.zero,
                  icon: const RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.subdirectory_arrow_left,
                      color: Color(0xFF018D5C),
                      size: 20,
                      // weight: 30,
                    ),
                  ),
                  onPressed: () {
                    widget.onIndexChanged(1);
                    widget.onTappedChanged(widget.vendor);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
