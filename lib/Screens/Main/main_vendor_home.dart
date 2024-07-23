import 'package:flutter/material.dart';

class MainVendorHome extends StatefulWidget {
  const MainVendorHome({super.key});

  @override
  State<MainVendorHome> createState() => _MainVendorHomeState();
}

class _MainVendorHomeState extends State<MainVendorHome> {
  bool _isPetrol = false;
  bool _isDiesel = false;
  bool _isGas = false;

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required error,
  }) {
    return TextField(
      style: const TextStyle(fontSize: 14),
      controller: controller,
      decoration: InputDecoration(
        // prefixIcon: const Icon(
        //   Icons.attach_money,
        //   size: 16,
        // ),
        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        // labelText: label,
        hintText: "₦ $label",
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

  final Map<String, String?> _errors = {
    'diesel': null,
    'gas': null,
    'petrol': null,
  };

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
            const SizedBox(height: 20),
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
                      label: ""),
                )
              ],
            ),
            const SizedBox(height: 20),
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
                      label: ""),
                )
              ],
            ),
            const SizedBox(height: 20),
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
                      label: ""),
                )
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  // _validateInputs();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(116, 40),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  "Update Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
          color: value ? Colors.green : Colors.grey,
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
