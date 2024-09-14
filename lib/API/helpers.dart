import 'package:fuel_dey_buyers/Model/user.dart';

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  } else {
    return input.split(' ').map((word) {
      if (word.isNotEmpty && !isUpperCase(word)) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word;
      }
    }).join(' ');
  }
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) {
    return input;
  } else {
    return input[0].toUpperCase() + input.substring(1);
  }
}

bool isUpperCase(String input) {
  if (input == input.toUpperCase()) {
    return true;
  } else {
    return false;
  }
}

// List<Vendor> parseVendors(String responseBody) {
//   // Decode JSON string into a list of dynamic maps
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   // final List<dynamic> parsed = jsonDecode(responseBody);

//   return parsed.map<Vendor>((json) => Vendor.fromJson(json)).toList();
// }

// List<Vendor> parseVendors(String responseBody) {
//   // Decode JSON string into a list of dynamic maps
//   final List<dynamic> parsed = jsonDecode(responseBody);

//   return parsed.map<Vendor>((json) => Vendor.fromJson(json)).toList();
// }

List<Vendor> parseVendors(List<Vendor> vendorList) {
  // Directly map the dynamic list to a list of Vendor objects
  return vendorList
      .map<Vendor>((json) => Vendor.fromJson(json as Map<String, dynamic>))
      .toList();
}
