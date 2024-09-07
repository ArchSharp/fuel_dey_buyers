// import 'dart:convert';

import 'dart:io';

class CommuterPayload {
  String email;
  String password;
  String firstname;
  String lastname;
  // String middlename;
  String phonenumber;

  CommuterPayload({
    required this.email,
    required this.password,
    required this.firstname,
    required this.lastname,
    // required this.middlename,
    required this.phonenumber,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
      "firstname": firstname,
      "lastname": lastname,
      // "middle_name": middlename,
      "phonenumber": phonenumber,
    };
  }

  // Create UserPayload from JSON
  factory CommuterPayload.fromJson(Map<String, dynamic> json) {
    return CommuterPayload(
      email: json['email'],
      password: json['password'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      // middlename: json['middle_name'],
      phonenumber: json['phonenumber'],
    );
  }
}

class UserSignInPayload {
  String email;
  String password;

  UserSignInPayload({
    required this.email,
    required this.password,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }

  // Create UserPayload from JSON
  factory UserSignInPayload.fromJson(Map<String, dynamic> json) {
    return UserSignInPayload(
      email: json['email'],
      password: json['password'],
    );
  }
}

class VendorSignUpPayload {
  String stationname;
  String address;
  String latitude;
  String longitude;
  String state;
  String lga;
  String email;
  String phonenumber;
  String password;

  VendorSignUpPayload({
    required this.stationname,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.state,
    required this.lga,
    required this.email,
    required this.phonenumber,
    required this.password,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "stationname": stationname,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "state": state,
      "lga": lga,
      "email": email,
      "phonenumber": phonenumber,
      "password": password,
    };
  }

  // Create UserPayload from JSON
  factory VendorSignUpPayload.fromJson(Map<String, dynamic> json) {
    return VendorSignUpPayload(
      stationname: json['stationname'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      state: json['state'],
      lga: json['lga'],
      email: json['email'],
      phonenumber: json['phonenumber'],
      password: json['password'],
    );
  }
}

class GetAllVendorsPayload {
  String userid;
  String state;
  String lga;
  String latitude;
  String longitude;

  GetAllVendorsPayload({
    required this.userid,
    required this.state,
    required this.lga,
    required this.latitude,
    required this.longitude,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "state": state,
      "lga": lga,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  // Create UserPayload from JSON
  factory GetAllVendorsPayload.fromJson(Map<String, dynamic> json) {
    return GetAllVendorsPayload(
      userid: json['userid'],
      state: json['state'],
      lga: json['lga'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class RateVendorPayload {
  String userid;
  String vendorid;
  int rating;
  String review;

  RateVendorPayload({
    required this.userid,
    required this.vendorid,
    required this.rating,
    required this.review,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "userid": userid,
      "vendorid": vendorid,
      "rating": rating,
      "review": review,
    };
  }

  // Create UserPayload from JSON
  factory RateVendorPayload.fromJson(Map<String, dynamic> json) {
    return RateVendorPayload(
      userid: json['userid'],
      vendorid: json['vendorid'],
      rating: json['rating'],
      review: json['review'],
    );
  }
}

class VendorReviewsPayload {
  String vendorId;

  VendorReviewsPayload({
    required this.vendorId,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "vendorid": vendorId,
    };
  }

  // Create UserPayload from JSON
  factory VendorReviewsPayload.fromJson(Map<String, dynamic> json) {
    return VendorReviewsPayload(
      vendorId: json['vendorid'],
    );
  }
}

class UpdateVendorPayload {
  double gasPrice;
  double petrolPrice;
  double dieselPrice;
  bool isdiesel;
  bool ispetrol;
  bool isgas;
  String vendorId;

  UpdateVendorPayload({
    required this.vendorId,
    required this.gasPrice,
    required this.dieselPrice,
    required this.petrolPrice,
    required this.isdiesel,
    required this.isgas,
    required this.ispetrol,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "vendorid": vendorId,
      "gasprice": gasPrice,
      "petrolprice": petrolPrice,
      "dieselprice": dieselPrice,
      "isgas": isgas,
      "isdiesel": isdiesel,
      "ispetrol": ispetrol,
    };
  }

  // Create UserPayload from JSON
  factory UpdateVendorPayload.fromJson(Map<String, dynamic> json) {
    return UpdateVendorPayload(
      vendorId: json['vendorid'],
      dieselPrice: json['dieselprice'],
      gasPrice: json['gasprice'],
      petrolPrice: json['petrolprice'],
      isgas: json['isgas'],
      ispetrol: json['ispetrol'],
      isdiesel: json['isdiesel'],
    );
  }
}

class UploadImagePayload {
  File file;
  bool isVendor;
  String userId;

  UploadImagePayload({
    required this.userId,
    required this.file,
    required this.isVendor,
  });

  // Convert UserPayload to JSON
  Map<String, dynamic> toJson() {
    return {
      "userid": userId,
      "file": file,
      "isvendor": isVendor,
    };
  }

  // Create UserPayload from JSON
  factory UploadImagePayload.fromJson(Map<String, dynamic> json) {
    return UploadImagePayload(
      userId: json['userid'],
      file: json['file'],
      isVendor: json['isvendor'],
    );
  }
}

class Vendor {
  final String id;
  final String stationName;
  final String address;
  final double latitude;
  final double longitude;
  final bool isPetrol;
  final int petrolPrice;
  final bool isGas;
  final int gasPrice;
  final bool isDiesel;
  final int dieselPrice;
  final int averageRating;
  final int totalRaters;
  final int commuterRating;
  final List<RatingCount> ratingCount;
  final String state;
  final String lga;
  final String email;
  final String phoneNumber;
  final DateTime updatedAt;
  final DateTime createdAt;

  Vendor({
    required this.id,
    required this.stationName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.isPetrol,
    required this.petrolPrice,
    required this.isGas,
    required this.gasPrice,
    required this.isDiesel,
    required this.dieselPrice,
    required this.averageRating,
    required this.totalRaters,
    required this.commuterRating,
    required this.ratingCount,
    required this.state,
    required this.lga,
    required this.email,
    required this.phoneNumber,
    required this.updatedAt,
    required this.createdAt,
  });

  // Factory method to create a Vendor object from JSON
  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'] as String,
      stationName: json['stationname'] as String,
      address: json['address'] as String,
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      isPetrol: json['ispetrol'] as bool,
      petrolPrice: json['petrolprice'] as int,
      isGas: json['isgas'] as bool,
      gasPrice: json['gasprice'] as int,
      isDiesel: json['isdiesel'] as bool,
      dieselPrice: json['dieselprice'] as int,
      averageRating: json['averagerating'] as int,
      totalRaters: json['totalrater'] as int,
      commuterRating: json['commuterrating'] as int,
      ratingCount: (json['ratingcount'] as List)
          .map((e) => RatingCount.fromJson(e))
          .toList(),
      state: json['state'] as String,
      lga: json['lga'] as String,
      email: json['email'] as String,
      phoneNumber: json['phonenumber'] as String,
      updatedAt: DateTime.parse(json['updatedat'] as String),
      createdAt: DateTime.parse(json['createdat'] as String),
    );
  }
}

class RatingCount {
  final int rating;
  final int totalRaters;

  RatingCount({
    required this.rating,
    required this.totalRaters,
  });

  // Factory method to create a RatingCount object from JSON
  factory RatingCount.fromJson(Map<String, dynamic> json) {
    return RatingCount(
      rating: json['rating'] as int,
      totalRaters: json['totalraters'] as int,
    );
  }
}





// void main() {
//   // Sample payload data
//   String email = 'john.doe@example.com';
//   String pass = 'password123';
//   DateTime dateOfBirth = DateTime(1990, 12, 31);
//   String fname = 'John';
//   String lname = 'Doe';
//   String mname = 'Middle';
//   String phone = '1234567890';

//   // Create an instance of UserPayload
//   UserPayload userPayload = UserPayload(
//     email: email,
//     password: pass,
//     dateOfBirth: dateOfBirth
//         .toString()
//         .replaceAll(RegExp(r' 00:00:00.000'), 'T00:00:00+00:00'),
//     firstname: fname,
//     lastname: lname,
//     middleName: mname,
//     phoneNumber: phone,
//   );

//   // Convert UserPayload to JSON
//   Map<String, dynamic> payloadJson = userPayload.toJson();
//   String payloadJsonString = jsonEncode(payloadJson);

//   // Print the JSON representation
//   print(payloadJsonString);

//   // Convert JSON back to UserPayload
//   Map<String, dynamic> decodedJson = jsonDecode(payloadJsonString);
//   UserPayload decodedUserPayload = UserPayload.fromJson(decodedJson);

//   // Access properties of decodedUserPayload
//   print(decodedUserPayload.email);
//   print(decodedUserPayload.dateOfBirth);
//   print(decodedUserPayload.phoneNumber);
// }
