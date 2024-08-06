import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CommuterNavbar extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;
  final int currentIndex;

  const CommuterNavbar({
    super.key,
    required this.onIndexChanged,
    required this.currentIndex,
  });

  @override
  State<CommuterNavbar> createState() => _CommuterNavbarState();
}

class _CommuterNavbarState extends State<CommuterNavbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // backgroundColor: const Color.fromRGBO(255, 253, 244, 0.1),
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: SvgPicture.asset(
              'assets/svgs/home.svg',
              width: 18.0,
              height: 19.0,
              colorFilter: ColorFilter.mode(
                widget.currentIndex == 0
                    ? const Color(0xFFECB920)
                    : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 1
                ? Icons.bookmark_sharp
                : Icons.bookmark_border_sharp,
            color: widget.currentIndex == 1
                ? const Color(0xFFECB920)
                : Colors.grey,
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 2
                ? Icons.notifications
                : Icons.notifications_outlined,
            color: widget.currentIndex == 2
                ? const Color(0xFFECB920)
                : Colors.grey,
          ),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 3
                ? Icons.settings_sharp
                : Icons.settings_outlined,
            color: widget.currentIndex == 3
                ? const Color(0xFFECB920)
                : Colors.grey,
          ),
          label: 'Setting',
        ),
      ],
      selectedItemColor: const Color(0xFFECB920),
      unselectedItemColor: const Color(0xFF2C2D2F),
      selectedLabelStyle: const TextStyle(
          color: Color(0xFFECB920), fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(
          color: Color(0xFF2C2D2F), fontSize: 10, fontWeight: FontWeight.w600),
      onTap: (index) {
        setState(() {
          widget.onIndexChanged(index);
        });
      },
    );
  }
}
