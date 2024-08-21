import 'dart:io';
import 'package:fuel_dey_buyers/API/helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:permission_handler/permission_handler.dart';

class MainVendorSettings extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const MainVendorSettings({
    super.key,
    required this.onIndexChanged,
  });

  @override
  State<MainVendorSettings> createState() => _MainVendorSettingsState();
}

class _MainVendorSettingsState extends State<MainVendorSettings> {
  File? _image;

  Future<void> _pickImage() async {
    // Request permission to access photos
    final status = await Permission.storage.request();

    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } else if (status.isDenied) {
      // Handle permission denied
      print('Permission denied');
    } else if (status.isPermanentlyDenied) {
      // Handle permission permanently denied
      print('Permission permanently denied');
      // Optionally, open the app settings
      // openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double mtop = 0.07 * deviceHeight;

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store, //store.state.user
      builder: (context, store /*user*/) {
        var stationname = capitalize(store.state.user['stationname']);
        var email = store.state.user['email'];
        var phonenumber = store.state.user['phonenumber'];
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
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/images/vendor_img.png'),
                      // child: Image.asset(
                      //   'assets/images/vendor_img.png',
                      //   fit: BoxFit.contain,
                      //   // height: imgHeight,
                      //   // width: imgWidth,
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
                          color: Color(0xFFECB920),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.photo_camera_outlined,
                            color: Color(0xFF2C2D2F),
                          ),
                          onPressed: () {
                            // print("Icon button pressed");
                            _pickImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              stationname,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.mail_outline,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.phone,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Text(
                  phonenumber,
                  style: const TextStyle(
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
                backgroundColor: const Color(0xFFECB920),
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
                    color: Color(0xFF2C2D2F),
                  ),
                  Text(
                    "Edit",
                    style: TextStyle(
                      color: Color(0xFF2C2D2F),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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
                        Icons.local_gas_station_outlined,
                        size: 24,
                        color: Color(0xFF2C2D2F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Total stations",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C2D2F),
                          fontWeight: FontWeight.w600,
                        ),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C2D2F),
                          fontWeight: FontWeight.w600,
                        ),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C2D2F),
                          fontWeight: FontWeight.w600,
                        ),
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C2D2F),
                          fontWeight: FontWeight.w600,
                        ),
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
                          widget.onIndexChanged(1);
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
                          widget.onIndexChanged(2);
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
      },
    );
  }
}
