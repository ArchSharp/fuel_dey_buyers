import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/ratings_bar.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/star_ratings.dart';
import 'package:fuel_dey_buyers/Screens/SupportingScreens/user_star_rating.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

class OnTappedStation extends StatefulWidget {
  final String stationName;
  final String location;
  final String phone;
  final IconData icon;
  final bool isFuelAvailable;
  final ValueChanged<int> onIndexChangedFunc;
  final Vendor vendor;
  final Position? userCoordinates;

  const OnTappedStation({
    super.key,
    required this.stationName,
    required this.location,
    required this.phone,
    required this.icon,
    required this.isFuelAvailable,
    required this.onIndexChangedFunc,
    required this.vendor,
    required this.userCoordinates,
  });

  @override
  State<OnTappedStation> createState() => _OnTappedStationState();
}

class _OnTappedStationState extends State<OnTappedStation> {
  bool showOpenCloseTime = false;
  bool showAllReview = false;
  bool isLoading = false;
  String fiveStarNum = "";
  String fourStarNum = "";
  String threeStarNum = "";
  String twoStarNum = "";
  String oneStarNum = "";

  double fiveStarPercent = 0;
  double fourStarPercent = 0;
  double threeStarPercent = 0;
  double twoStarPercent = 0;
  double oneStarPercent = 0;

  String? estimatedTime = "";
  String? distance = "";

  List<dynamic> allVendorReviews = [];

  final DraggableScrollableController _scrollableController =
      DraggableScrollableController();
  final ValueNotifier<double> _heightPercentageNotifier =
      ValueNotifier<double>(0.5);

  @override
  void initState() {
    super.initState();
    _getVendorReviews();
    _getVendorDistanceAndTime();
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

  Future<void> _getVendorDistanceAndTime() async {
    LatLng origin = LatLng(
        widget.userCoordinates!.latitude, widget.userCoordinates!.longitude);

    LatLng destination =
        LatLng(widget.vendor.latitude, widget.vendor.longitude);
    // Fetch travel details using the origin and destination
    final travelDetails = await fetchTravelDetails(origin, destination);
    setState(() {
      estimatedTime = travelDetails.time;
      distance = travelDetails.distance;
    });
    print('OnTapped Station Distance: ${travelDetails.distance}');
    print('OnTapped Station Duration: ${travelDetails.time}');
  }

  Future<void> _getVendorReviews() async {
    // print("gotten here: ${widget.vendor['id']}");
    VendorReviewsPayload payload = VendorReviewsPayload(
      vendorId: widget.vendor.id,
    );
    //get vendor reviews
    await getAllVendorReviewsById(payload);
  }

  Future<void> handleRateVendor(RateVendorPayload payload) async {
    setState(() {
      isLoading = true;
    });

    try {
      // print("payload: $userPayload");
      Tuple2<int, String> result = await rateVendor(payload);

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
    // double deviceWidth = MediaQuery.of(context).size.width - 32;
    double deviceHeight = MediaQuery.of(context).size.height;

    double initialHeight = 0.5;
    double minHeight = 0.5;
    double maxHeight = 0.8;

    fiveStarNum = widget.vendor.ratingCount[0].totalRaters.toString();

    fourStarNum = widget.vendor.ratingCount[1].totalRaters.toString();
    threeStarNum = widget.vendor.ratingCount[2].totalRaters.toString();
    twoStarNum = widget.vendor.ratingCount[3].totalRaters.toString();
    oneStarNum = widget.vendor.ratingCount[4].totalRaters.toString();

    fiveStarPercent =
        widget.vendor.ratingCount[0].totalRaters / widget.vendor.totalRaters;

    fourStarPercent =
        widget.vendor.ratingCount[1].totalRaters / widget.vendor.totalRaters;
    threeStarPercent =
        widget.vendor.ratingCount[2].totalRaters / widget.vendor.totalRaters;
    twoStarPercent =
        widget.vendor.ratingCount[3].totalRaters / widget.vendor.totalRaters;
    oneStarPercent =
        widget.vendor.ratingCount[4].totalRaters / widget.vendor.totalRaters;

    return DraggableScrollableSheet(
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
                            // mainAxisSize : MainAxisSize.min,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.circle, // or Icons.brightness_1
                                        size: 10.0,
                                        color: Color(0xFFA9E27C),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        widget.stationName,
                                        style: const TextStyle(
                                          color: Color(0xFF2C2D2F),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const SizedBox(width: 24),
                                      Text(
                                        "${double.parse(widget.vendor.averageRating.toString())}",
                                        style: const TextStyle(
                                          color: Color(0xFF2C2D2F),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      StarRatings(
                                          rating: double.parse(widget
                                              .vendor.averageRating
                                              .toString()),
                                          starSize: 12),
                                      const SizedBox(width: 5),
                                      Text(
                                        '(${double.parse(widget.vendor.totalRaters.toString())})',
                                        style: const TextStyle(
                                          color: Color(0xFF2C2D2F),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(0),
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF018D5C),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 14,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.ios_share_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    // Navigator.pushReplacementNamed(
                                    //     context, '/commuter_signup');
                                  },
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF018D5C),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  iconSize: 14,
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(
                                    Icons.favorite_outline_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    widget.onIndexChangedFunc(3);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "Distance",
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  distance ?? "",
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
                                  widget.icon,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  estimatedTime ?? "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: height < 0.55 ? 8 : 0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.location,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ),
                        if (height >= 0.55) const SizedBox(height: 10),
                        if (height >= 0.55)
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                widget.phone,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        if (height >= 0.55) const Divider(),
                        if (height >= 0.55)
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Open . Close 10pm",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        setState(() {
                                          showOpenCloseTime =
                                              !showOpenCloseTime;
                                        });
                                      },
                                      icon: Transform.rotate(
                                        angle: showOpenCloseTime
                                            ? 180 * (3.141592653589793 / 180)
                                            : 0 * (3.141592653589793 / 180),
                                        child: const Icon(
                                            Icons.keyboard_arrow_down),
                                      ),
                                    ),
                                  ],
                                ),
                                if (showOpenCloseTime)
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "“...very close to the main road for easy access”",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
                          child: const Row(
                            children: [
                              Icon(
                                Icons.local_gas_station_outlined,
                                color: Colors.black,
                              ),
                              SizedBox(width: 10),
                              Text(
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
                          // padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 4, 20, 4),
                                  minimumSize: const Size(70, 22),
                                  backgroundColor: const Color(0xFF018D5C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Petrol",
                                      style: TextStyle(
                                        color: Color(0xFFFFFDF4),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (height >= 0.55)
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svgs/money.svg',
                                            width: 12.0,
                                            height: 12.0,
                                            colorFilter: const ColorFilter.mode(
                                              Color(0xFFC9C9C9),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.vendor.petrolPrice
                                                .toString(),
                                            style: const TextStyle(
                                              color: Color(0xFFFFFDF4),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 4, 20, 4),
                                  minimumSize: const Size(70, 22),
                                  backgroundColor: const Color(0xFFE15623),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Gas",
                                      style: TextStyle(
                                        color: Color(0xFFFFFDF4),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (height >= 0.55)
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svgs/money.svg',
                                            width: 12.0,
                                            height: 12.0,
                                            colorFilter: const ColorFilter.mode(
                                              Color(0xFFFFFDF4),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.vendor.gasPrice.toString(),
                                            style: const TextStyle(
                                              color: Color(0xFFFFFDF4),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 4, 20, 4),
                                  minimumSize: const Size(70, 22),
                                  backgroundColor: const Color(0xFF018D5C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "Diesel",
                                      style: TextStyle(
                                        color: Color(0xFFFFFDF4),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                    if (height >= 0.55)
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svgs/money.svg',
                                            width: 12.0,
                                            height: 12.0,
                                            colorFilter: const ColorFilter.mode(
                                              Color(0xFFC9C9C9),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            widget.vendor.dieselPrice
                                                .toString(),
                                            style: const TextStyle(
                                              color: Color(0xFFFFFDF4),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (height >= 0.55) const Divider(),
                        if (height >= 0.55)
                          Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Review Summary",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 68,
                                    child: Column(
                                      children: [
                                        Text(
                                          "${double.parse(widget.vendor.averageRating.toString())}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2C2D2F),
                                          ),
                                        ),
                                        StarRatings(
                                          rating: double.parse(widget
                                              .vendor.averageRating
                                              .toString()),
                                          starSize: 12,
                                        ),
                                        Text(
                                          "(${widget.vendor.totalRaters})",
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: Color(0xFFC9C9C9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  RatingsBar(
                                    ratings: [
                                      fiveStarPercent.isNaN
                                          ? 0.0
                                          : fiveStarPercent,
                                      fourStarPercent.isNaN
                                          ? 0.0
                                          : fourStarPercent,
                                      threeStarPercent.isNaN
                                          ? 0.0
                                          : threeStarPercent,
                                      twoStarPercent.isNaN
                                          ? 0.0
                                          : twoStarPercent,
                                      oneStarPercent.isNaN
                                          ? 0.0
                                          : oneStarPercent
                                    ],
                                    tips: [
                                      '$fiveStarNum people gave 5 star',
                                      '$fourStarNum people gave 4 star',
                                      '$threeStarNum people gave 3 star',
                                      '$twoStarNum people gave 2 star',
                                      '$oneStarNum people gave 1 star',
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "“...very close to the main road for easy access”",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      var reviews =
                                          store.state.allVendorReviews;

                                      if (reviews.isNotEmpty) {
                                        allVendorReviews = reviews;
                                      }

                                      showAllReview = !showAllReview;
                                    });
                                  },
                                  child: const Text(
                                    "See all reviews",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Color(0xFF018D5C),
                                    ),
                                  ),
                                ),
                              ),
                              if (showAllReview)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    children: allVendorReviews.map((review) {
                                      String reviewText = "${review['review']}";
                                      if (reviewText.length > 35) {
                                        reviewText =
                                            "${reviewText.substring(0, 40)}...";
                                      }

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.account_circle,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "“$reviewText”",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              const Divider(),
                              const SizedBox(height: 5),
                              const Text(
                                "Rate and Review",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  UserStarRating(
                                    initialRating: double.parse(widget
                                        .vendor.commuterRating
                                        .toString()),
                                    onRatingChanged: (newRating) {
                                      RateVendorPayload payload =
                                          RateVendorPayload(
                                        userid: store.state.user['id'],
                                        vendorid: widget.vendor.id,
                                        rating: newRating.toInt(),
                                        review: "review",
                                      );
                                      print(
                                          'New rating: ${payload.userid} ${payload.vendorid} ${payload.rating} ${payload.review}');
                                      handleRateVendor(payload);
                                    },
                                  ),
                                  if (isLoading) const SizedBox(width: 5),
                                  if (isLoading)
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.orange,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.access_time_outlined,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    "Your visits and Maps activity",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.keyboard_arrow_right,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {
                            widget.onIndexChangedFunc(2);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 52),
                            backgroundColor: const Color(0xFF018D5C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Navigate",
                                style: TextStyle(
                                  color: Color(0xFFFFFDF4),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Transform.rotate(
                                angle: 50 * (3.141592653589793 / 180),
                                child: const Icon(
                                  Icons.navigation_outlined,
                                  color: Color(0xFFFFFDF4),
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
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
    );
  }
}
