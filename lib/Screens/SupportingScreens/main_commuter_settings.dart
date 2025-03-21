import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signin.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tuple/tuple.dart';

class MainCommuterSettings extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const MainCommuterSettings({
    super.key,
    required this.onIndexChanged,
  });

  @override
  State<MainCommuterSettings> createState() => _MainCommuterSettingsState();
}

class _MainCommuterSettingsState extends State<MainCommuterSettings> {
  File? _image;
  bool isLoading = false;

  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Request permission to access photos
      // final status = await Permission.photos.request();
      final status = await Permission.storage.request();
      // print("gotten here");

      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });

          var commuterId = store.state.user['id'];
          UploadImagePayload payload = UploadImagePayload(
            file: File(pickedFile.path),
            isVendor: false,
            userId: commuterId,
          );
          Tuple2<int, String> result = await uploadImgToDrive(payload);

          if (mounted) {
            if (result.item1 == 1) {
              myNotificationBar(
                  context, "Image Uploaded successfully", "success");
              await getCommuterById(commuterId);
            }
          }
        }
      } else if (status.isDenied) {
        // Permission is denied, you can request it again
        print('Permission denied');
        await Permission.storage.request();
      } else if (status.isPermanentlyDenied) {
        // Permission is permanently denied, show a dialog guiding the user to settings
        print('Permission permanently denied');
        bool opened = await openAppSettings();
        if (!opened) {
          // Optionally handle the case where the settings could not be opened
          print('Failed to open app settings');
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
    double deviceHeight = MediaQuery.of(context).size.height;
    double mtop = 0.07 * deviceHeight;

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store, //store.state.user
      builder: (context, store) {
        // print("this commuter ${store.state.user}");
        var imageUrl = store.state.user['imageurl'];
        String commuterImage =
            "https://drive.google.com/thumbnail?id=$imageUrl";
        var fname = store.state.user['firstname'];
        var lname = store.state.user['lastname'];
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
                          : imageUrl == null || imageUrl == ""
                              ? const AssetImage('assets/images/commuter.png')
                              : NetworkImage(commuterImage) as ImageProvider,
                    ),
                    if (isLoading == true)
                      const Positioned(
                        top: 72.5,
                        left: 72.5,
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
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
                            color: Colors.black,
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
              "$lname $fname",
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
                  "$email",
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
                  "$phonenumber",
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
            const Divider(color: Color(0xFFC1C1C1)),
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
                        Icons.timeline_outlined,
                        size: 24,
                        color: Color(0xFF2C2D2F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Your Timeline",
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
                        Icons.timeline_outlined,
                        size: 24,
                        color: Color(0xFF2C2D2F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Total station visited: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF2C2D2F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "10",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFC9C9C9),
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
                  GestureDetector(
                    onTap: () {
                      logoutFn();
                      Navigator.popAndPushNamed(
                          context, CommuterSignin.routeName);
                    },
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 24,
                          color: Color(0xFF2C2D2F),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Log Out",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2C2D2F),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Other",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFC9C9C9),
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
