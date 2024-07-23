import 'package:flutter/material.dart';

class MainCommuterSettings extends StatelessWidget {
  final ValueChanged<int> onIndexChanged;

  const MainCommuterSettings({
    super.key,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double mtop = 0.07 * deviceHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: mtop),
        Center(
          child: Container(
            width: 189,
            height: 165,
            padding: const EdgeInsets.all(0),
            decoration: const BoxDecoration(
                // border: Border.all(width: 1, color: Colors.black),
                ),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 82.5,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      const AssetImage('assets/images/commuter.png'),
                  // child: const Icon(
                  //   Icons.help,
                  //   color: Colors.white, // Icon color
                  //   size: 30, // Icon size
                  // ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2D2F),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 24,
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.photo_camera_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, '/commuter_signup');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Yemi Lade",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.mail_outline,
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              "yemilade@gmail.com",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.phone,
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              "+234 810 153 2597",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Navigator.pushReplacementNamed(context, CommuterSignup.routeName);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            fixedSize: const Size(78, 32),
            backgroundColor: const Color(0xFF2C2D2F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.edit,
                size: 18,
                color: Color(0xFFF8F8F8),
              ),
              Text(
                "Edit",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Divider(
          color: Color(0xFFC1C1C1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 24,
                    color: Color(0xFF2C2D2F),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Favorite stations",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.timeline_outlined,
                    size: 24,
                    color: Color(0xFF2C2D2F),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Your Timeline",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.settings_outlined,
                    size: 24,
                    color: Color(0xFF2C2D2F),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Other",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFFACACAC),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 24,
                    color: Color(0xFF2C2D2F),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "FAQ",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outlined,
                    size: 24,
                    color: Color(0xFF2C2D2F),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Help and Feedback",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      onIndexChanged(1);
                    },
                    child: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2C2D2F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                  TextButton(
                    onPressed: () {
                      onIndexChanged(2);
                    },
                    child: const Text(
                      "Terms and conditions",
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF2C2D2F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
