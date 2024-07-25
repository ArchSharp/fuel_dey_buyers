import 'package:flutter/material.dart';

class VendorNavbar extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const VendorNavbar({
    super.key,
    required this.onIndexChanged,
  });

  @override
  State<VendorNavbar> createState() => _VendorNavbarState();
}

class _VendorNavbarState extends State<VendorNavbar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 0 ? Icons.home : Icons.home_outlined,
            color: _currentIndex == 0 ? const Color(0xFFECB920) : Colors.grey,
          ),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     _currentIndex == 1
        //         ? Icons.bookmark_sharp
        //         : Icons.bookmark_border_sharp,
        //     color: _currentIndex == 1 ? const Color(0xFF2C2D2F) : Colors.grey,
        //   ),
        //   label: 'Favorite',
        // ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 1
                ? Icons.notifications
                : Icons.notifications_outlined,
            color: _currentIndex == 1 ? const Color(0xFFECB920) : Colors.grey,
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _currentIndex == 2 ? Icons.settings_sharp : Icons.settings_outlined,
            color: _currentIndex == 2 ? const Color(0xFFECB920) : Colors.grey,
          ),
          label: 'Setting',
        ),
      ],
      selectedLabelStyle: const TextStyle(
          color: Color(0xFFECB920), fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
          color: Color(0xFF2C2D2F), fontSize: 10, fontWeight: FontWeight.w600),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        widget.onIndexChanged(index);
      },
    );
  }
}
