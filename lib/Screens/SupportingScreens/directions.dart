import 'package:flutter/material.dart';

class Directions extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const Directions({
    super.key,
    required this.onIndexChanged,
  });

  @override
  State<Directions> createState() => _DirectionsState();
}

class _DirectionsState extends State<Directions> {
  bool showDots = true;
  // List of items
  final List<String> items = [
    'My Location',
    'Oando Fuel Station',
    // 'Mobil Fuel Station',
    // 'NNPC Fuel Station',
    // 'Total Fuel Station',
    'Add Stop'
  ];

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
    // double deviceWidth = MediaQuery.of(context).size.width - 32;
    double deviceHeight = MediaQuery.of(context).size.height;

    double initialHeight = 0.3;
    double minHeight = 0.3;
    double maxHeight = 0.5;

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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: const Color(0xFF2C2D2F),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            iconSize: 16,
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.directions_car),
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
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            iconSize: 16,
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.directions_walk),
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
                                      widget.onIndexChanged(1);
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
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(0),
                            // decoration: BoxDecoration(border: Border.all(width: 1)),
                            constraints: BoxConstraints(
                              minHeight:
                                  100, // Set a minimum height for the list
                              maxHeight: (60 * items.length)
                                  .toDouble(), // Set a maximum height for the list
                            ),
                            child: ReorderableListView(
                              onReorderStart: (int selectedIndex) {
                                setState(() {
                                  showDots = false;
                                });
                              },
                              onReorderEnd: (int selectedIndex) {
                                setState(() {
                                  showDots = true;
                                });
                              },
                              onReorder: (int oldIndex, int newIndex) {
                                setState(() {
                                  if (newIndex > oldIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = items.removeAt(oldIndex);
                                  items.insert(newIndex, item);
                                });
                              },
                              children: [
                                for (int index = 0;
                                    index < items.length;
                                    index++)
                                  Container(
                                    key: ValueKey(items[index]),
                                    // decoration: BoxDecoration(border: Border.all(width: 1)),
                                    child: Stack(
                                      children: [
                                        Column(
                                          // key: ValueKey(items[index]),
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 0,
                                                        right: 20,
                                                        top: 0,
                                                        bottom: 0),
                                                title: Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  // mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      width: 25,
                                                      height: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xFF2C2D2F),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: index == 0
                                                          ? Transform.rotate(
                                                              angle: 50 *
                                                                  (3.141592653589793 /
                                                                      180),
                                                              child: const Icon(
                                                                Icons
                                                                    .navigation_outlined,
                                                                color: Color(
                                                                    0xFFC9C9C9),
                                                                size: 14,
                                                              ),
                                                            )
                                                          : index == 1
                                                              ? const Icon(
                                                                  Icons
                                                                      .location_on_outlined,
                                                                  size: 14,
                                                                  color: Color(
                                                                      0xFFC9C9C9),
                                                                )
                                                              : const Icon(
                                                                  Icons.add,
                                                                  size: 14,
                                                                  color: Color(
                                                                      0xFFC9C9C9),
                                                                ),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      items[index],
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                trailing: const Icon(
                                                  Icons.menu_rounded,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 15),
                                            if (index < items.length - 1)
                                              const Row(
                                                children: [
                                                  // SizedBox(width: 10),
                                                  // Icon(
                                                  //   Icons.circle,
                                                  //   size: 4,
                                                  //   color: Color(0xFF2C2D2F),
                                                  // ),
                                                  SizedBox(width: 32),
                                                  Expanded(child: Divider()),
                                                  SizedBox(width: 20),
                                                ],
                                              ),
                                          ],
                                        ),
                                        if (index < items.length - 1 &&
                                            showDots == true)
                                          const Positioned(
                                            top: 45,
                                            left: 10,
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 4,
                                                  color: Color(0xFF2C2D2F),
                                                ),
                                                SizedBox(height: 4),
                                                Icon(
                                                  Icons.circle,
                                                  size: 4,
                                                  color: Color(0xFF2C2D2F),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (index + 1 >= items.length - 1 &&
                                            showDots == true)
                                          const Positioned(
                                            top: 1,
                                            left: 10,
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 4,
                                                  color: Color(0xFF2C2D2F),
                                                ),
                                                SizedBox(height: 4),
                                                Icon(
                                                  Icons.circle,
                                                  size: 4,
                                                  color: Color(0xFF2C2D2F),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        child: Divider(
                          color: Colors.grey,
                          thickness: 5,
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
