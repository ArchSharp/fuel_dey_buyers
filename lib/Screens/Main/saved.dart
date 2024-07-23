import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/Screens/Main/main_favorites.dart';

class Saved extends StatefulWidget {
  const Saved({super.key});

  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  int _homeIndex = 0;

  void _updateHomeIndex(int newIndex) {
    setState(() {
      _homeIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double mtop = deviceHeight * 0.07;

    return _homeIndex == 0
        ? SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: mtop),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Saved",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushReplacementNamed(context, CommuterSignup.routeName);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          fixedSize: const Size(79, 32),
                          backgroundColor: const Color(0xFF2C2D2F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: const Text(
                          "+ New List",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: const BoxDecoration(color: Color(0xFFE7E3E3)),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2C2D2F),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            iconSize: 20,
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.home_outlined,
                              color: Color(0xFFC1C1C1),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/commuter_signup');
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Home",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Add your Home",
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
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.favorite_outline),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Favorite stations",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Private list . 0 places",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          _updateHomeIndex(1);
                        },
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.outlined_flag),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Where to go",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Private list . 0 places",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.label_outline_rounded),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Labelled",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Private list . 0 places",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                            SizedBox(width: 1),
                            Icon(
                              Icons.circle_outlined,
                              size: 8,
                              weight: 4,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      const Icon(Icons.star_outline_rounded),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Starred",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Private list . 0 places",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.circle_outlined,
                                size: 8,
                                weight: 4,
                                color: Colors.black,
                              ),
                              SizedBox(width: 1),
                              Icon(
                                Icons.circle_outlined,
                                size: 8,
                                weight: 4,
                                color: Colors.black,
                              ),
                              SizedBox(width: 1),
                              Icon(
                                Icons.circle_outlined,
                                size: 8,
                                weight: 4,
                                color: Colors.black,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(width: 1)),
                            child: IconButton(
                              iconSize: 14,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.timeline_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/commuter_signup');
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Timeline",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 60),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(width: 1)),
                            child: IconButton(
                              iconSize: 14,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.map_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/commuter_signup');
                              },
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Map",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : MainFavorites(onIndexChanged: _updateHomeIndex);
  }
}
