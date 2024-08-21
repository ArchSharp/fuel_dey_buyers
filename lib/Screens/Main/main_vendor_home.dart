import 'package:flutter/material.dart';
import 'package:fuel_dey_buyers/API/auths_functions.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Notifications/my_notification_bar.dart';
import 'package:tuple/tuple.dart';

class MainVendorHome extends StatefulWidget {
  const MainVendorHome({super.key});

  @override
  State<MainVendorHome> createState() => _MainVendorHomeState();
}

class _MainVendorHomeState extends State<MainVendorHome> {
  bool _isPetrol = false;
  bool _isDiesel = false;
  bool _isGas = false;
  bool isLoading = false;

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required int? maxLines,
    TextInputType keyboardType = TextInputType.text,
    required error,
  }) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        // prefixIcon: const Icon(
        //   Icons.attach_money,
        //   size: 16,
        // ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
        // labelText: label,
        hintText: label,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        errorText: error,
        errorStyle: const TextStyle(color: Colors.red),
        border: const OutlineInputBorder(
          borderSide: BorderSide(style: BorderStyle.solid),
        ),
      ),
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
    );
  }

  final TextEditingController _dieselController = TextEditingController();
  final TextEditingController _petrolController = TextEditingController();
  final TextEditingController _gasController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  final Map<String, String?> _errors = {
    'isdiesel': null,
    'isgas': null,
    'ispetrol': null,
    'dieselprice': null,
    'gasprice': null,
    'petrolprice': null,
  };

  Future<void> handleUpdateVendor() async {
    setState(() {
      isLoading = true;
    });

    String dieselprice = _dieselController.text.replaceAll("₦", "");

    String petrolprice = _petrolController.text.replaceAll("₦", "");

    String gasprice = _gasController.text.replaceAll("₦", "");

    // Create an instance of UserPayload
    UpdateVendorPayload userPayload = UpdateVendorPayload(
      vendorId: store.state.user['id'],
      gasPrice: double.parse(gasprice),
      dieselPrice: double.parse(dieselprice),
      petrolPrice: double.parse(petrolprice),
      isgas: _isGas,
      isdiesel: _isDiesel,
      ispetrol: _isPetrol,
    );

    print("isdiesel: ${userPayload.isdiesel}");

    try {
      // print("payload: ${userPayload.email}");
      Tuple2<int, String> result = await updateVendor(userPayload);
      if (result.item1 == 1) {
        if (mounted) {
          myNotificationBar(context, result.item2, "success");
          await getVendorById(userPayload.vendorId);
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
  void initState() {
    super.initState();
    var ispetrol = store.state.user['ispetrol'];
    var isdiesel = store.state.user['isdiesel'];
    var isgas = store.state.user['isgas'];
    var dieselprice = store.state.user['dieselprice'];
    var gasprice = store.state.user['gasprice'];
    var petrolprice = store.state.user['petrolprice'];

    // print(store.state.user);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // if (mounted) {
    setState(() {
      _isDiesel = isdiesel;
      _isGas = isgas;
      _isPetrol = ispetrol;
      _dieselController.text = "₦${dieselprice.toString()}";
      _gasController.text = "₦${gasprice.toString()}";
      _petrolController.text = "₦${petrolprice.toString()}";
    });
    // }
    // });
  }

  void _validateInputs() {
    setState(() {
      _errors['gasprice'] =
          _gasController.text.isEmpty ? 'Please enter gas price' : null;
      _errors['petrolprice'] =
          _petrolController.text.isEmpty ? 'Please enter petrol price' : null;
      _errors['dieselprice'] =
          _dieselController.text.isEmpty ? 'Please enter diesel price' : null;
    });

    if (_errors.values.every((error) => error == null)) {
      handleUpdateVendor();
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    // double imageWidth = deviceWidth * 0.8;
    double mtop = deviceHeight * 0.07;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mtop),
            const Text(
              "Set Fuel Price",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Availability of Fuel",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Petrol",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomSwitch(
                  value: _isPetrol,
                  onChanged: (value) {
                    setState(() {
                      _isPetrol = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Diesel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomSwitch(
                  value: _isDiesel,
                  onChanged: (value) {
                    setState(() {
                      _isDiesel = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Gas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomSwitch(
                  value: _isGas,
                  onChanged: (value) {
                    setState(() {
                      _isGas = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              "Input Prices",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Diesel Price Per Litre",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 80,
                  height: 39,
                  child: _buildTextField(
                    controller: _dieselController,
                    error: _errors['diesel'],
                    label: "₦",
                    maxLines: 1,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Petrol Price Per Litre",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 80,
                  height: 39,
                  child: _buildTextField(
                    controller: _petrolController,
                    error: _errors['petrol'],
                    label: "₦",
                    maxLines: 1,
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Gas Price Per Litre",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 80,
                  height: 39,
                  child: _buildTextField(
                    controller: _gasController,
                    error: _errors['gas'],
                    label: "₦",
                    maxLines: 1,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _validateInputs();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(116, 40),
                  backgroundColor: const Color(0xFFECB920),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Update Changes",
                  style: TextStyle(
                    color: Color(0xFF2C2D2F),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Details about station",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C2D2F),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 132,
              child: _buildTextField(
                controller: _detailsController,
                error: _errors['gas'],
                label: "",
                maxLines: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 35.0,
        height: 20.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: value ? const Color(0xFF018D5C) : Colors.grey,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              left: value ? 14.0 : 0.0,
              right: value ? 0.0 : 14.0,
              top: 2.5,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 14.0,
                height: 14.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
