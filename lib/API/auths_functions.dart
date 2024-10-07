import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuel_dey_buyers/API/utils.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

String? baseUrl = dotenv.env['BASE_URL'];
String? googleMapsApiKey = dotenv.env['GOOGLE_MAP_API_KEY'];
String? matrixBaseUrl = dotenv.env['GOOGLE_MATRIX_BASE_URL'];

Future<Tuple2<int, String>> signInVendorFn(UserSignInPayload payload) async {
  String apiUrl = '$baseUrl/api/SignInVendor';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload)); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    // print("signin response: ${data["body"]}");
    if (response.statusCode == 200) {
      // print(data["extrainfo"]);
      store.dispatch(UpdateUserAction(data['body']));
      store.dispatch(SaveUserToken(data["extrainfo"]));
      result = const Tuple2(1, "Login success");
    } else {
      // Handle errors
      print(
          'Request failed with status: ${response.statusCode}, responsePayload: $data');
      String msg = data['body'];
      if (msg.toLowerCase() == "please verify your email") {
        result = Tuple2(2, data['body']);
      } else if (msg.toLowerCase() == "incorrect password detected") {
        result = Tuple2(3, data['body']);
      } else if (msg.toLowerCase() == "user not found") {
        result = Tuple2(4, data['body']);
      }
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> signInCommuterFn(UserSignInPayload payload) async {
  String apiUrl = '$baseUrl/api/SignInCommuter';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload)); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    // print("signin response: ${data["body"]}");
    if (response.statusCode == 200) {
      // print(data["extrainfo"]);
      store.dispatch(UpdateUserAction(data['body']));
      store.dispatch(SaveUserToken(data["extrainfo"]));
      result = const Tuple2(1, "Login success");
    } else {
      // Handle errors
      print(
          'Request failed with status: ${response.statusCode}, responsePayload: $data');
      String msg = data['body'];
      if (msg.toLowerCase() == "please verify your email") {
        result = Tuple2(2, data['body']);
      } else if (msg.toLowerCase() == "incorrect password detected") {
        result = Tuple2(3, data['body']);
      } else if (msg.toLowerCase() == "user not found") {
        result = Tuple2(4, data['body']);
      }
    }
  } catch (e) {
    // Handle exceptions
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> signupCommuterFn(CommuterPayload payload) async {
  String apiUrl = '$baseUrl/api/NewCommuter';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  // print(payload);

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers,
        body: json
            .encode(payload.toJson())); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);

    // print('response: $data');
    if (response.statusCode == 201) {
      // print(data);
      result = const Tuple2(1, "Account created succesfully");
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');
      if (data['error'].toString().contains("parsing time")) {
        result = const Tuple2(2, 'There is error in date');
      } else {
        result = Tuple2(3, data['body']);
      }
    }
  } catch (e) {
    // Handle exceptions
    // print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> signupVendorFn(VendorSignUpPayload payload) async {
  String apiUrl = '$baseUrl/api/NewVendor';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  // print(payload);

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers,
        body: json
            .encode(payload.toJson())); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 201) {
      // print(data);
      result = const Tuple2(1, "Account created succesfully");
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      // print('check error: $data');
      if (data['error'].toString().contains("parsing time")) {
        result = const Tuple2(2, 'There is error in date');
      } else {
        result = Tuple2(3, data['body']);
      }
    }
  } catch (e) {
    // Handle exceptions
    // print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> verifyEmailFn(email, otp, isVendor) async {
  String apiUrl = '$baseUrl/api/CommuterVerifyEmail';
  if (isVendor == true) apiUrl = '$baseUrl/api/VendorVerifyEmail';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  final Map<String, dynamic> payload = {"email": email, "otp": otp};

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload)); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      String msg = data['body'];
      if (msg.contains("expired")) {
        result = Tuple2(2, msg);
      } else if (msg.contains("wrong")) {
        result = Tuple2(3, msg);
      }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> resendVerifyEmailFn(email, isVendor) async {
  String apiUrl = '$baseUrl/api/CommuterResendVerifyEmail';
  if (isVendor == true) apiUrl = '$baseUrl/api/VendorResendVerifyEmail';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  final Map<String, dynamic> payload = {"email": email};

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload)); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      // String msg = data['body'];
      // if (msg.contains("expired")) {
      //   result = Tuple2(2, msg);
      // } else if (msg.contains("wrong")) {
      //   result = Tuple2(3, msg);
      // }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> forgotPasswordFn(email, isVendor) async {
  String type =
      isVendor == true ? 'VendorForgotPassword' : 'CommuterForgotPassword';
  String apiUrl = '$baseUrl/api/$type?email=$email';

  // print(apiUrl);

  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.get(Uri.parse(apiUrl),
        headers: headers); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      String msg = data['body'];
      if (msg.contains("not found")) {
        result = Tuple2(2, msg);
      } else if (msg.contains("verify")) {
        result = Tuple2(3, msg);
      }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> resetPasswordFn(otp, newPassword, isVendor) async {
  String type =
      isVendor == true ? 'VendorResetPassword' : 'CommuterResetPassword';
  String apiUrl = '$baseUrl/api/$type';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${store.state.userToken["accesstoken"]}",
  };
  var email = store.state.email;
  email = isVendor == true ? email.replaceAll(RegExp(r'%2B'), "+") : email;
  final Map<String, dynamic> payload = {
    "email": email,
    "otp": otp,
    "newpassword": newPassword,
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.patch(Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload)); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      result = Tuple2(1, data['body']);
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');

      String msg = data['body'];
      if (msg.contains("not found")) {
        result = Tuple2(2, msg);
      } else if (msg.contains("verify")) {
        result = Tuple2(3, msg);
      } else if (msg.contains("invalid/wrong")) {
        result = Tuple2(4, msg);
      } else if (msg.contains("expired")) {
        result = Tuple2(5, msg);
      }
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> getNewToken(isVendor) async {
  String type =
      isVendor == true ? 'GetNewAccessToken' : 'CommuterGetNewAccessToken';
  String apiUrl =
      '$baseUrl/api/$type?refresh_token=${store.state.userToken["refreshtoken"]}';

  // print(apiUrl);

  final Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.get(Uri.parse(apiUrl),
        headers: headers); //.timeout(const Duration(seconds: 10));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      // print("new token: $data");
      result = Tuple2(1, data['access_token']);
      var usertoken = store.state.userToken;
      // print(
      //     "old token: ${usertoken["accesstoken"]} new token: ${data['access_token']}");
      usertoken["accesstoken"] = data['access_token'];
      store.dispatch(SaveUserToken(usertoken));
    } else {
      print(
          'Request failed with status: ${response.statusCode} response payload: $data');
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> getAllVendors(GetAllVendorsPayload payload) async {
  String path = '/api/CommuterGetAllVendors';

  // print("Calling get all vendors function");

  var result = const Tuple2(0, "");
  try {
    Response response = await dio.post(path, data: payload.toJson());

    final Map<String, dynamic> data = response.data;
    if (response.statusCode == 200) {
      // print("all vendors: ${data['body']}");
      // Assuming data['body'] is a List<dynamic> where each item is a Map<String, dynamic>
      if (data['message'] != "Vendors fetched empty") {
        final List<Vendor> vendors = (data['body'] as List<dynamic>)
            .map((item) => Vendor.fromJson(item as Map<String, dynamic>))
            .toList();
        store.dispatch(GetAllVendors(vendors));
        result = Tuple2(1, data['message']);
      } else if (data['message'] == "Vendors fetched empty") {
        result = Tuple2(2, data['body']);
      }
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data ${response.data['message']}');
      result = const Tuple2(3, "No Vendors");
    }
  } catch (e) {
    print('Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> getAllVendorReviewsById(
    VendorReviewsPayload payload) async {
  String path = '/api/GetAllVendorReviewsById?vendorId=${payload.vendorId}';

  var result = const Tuple2(0, "");
  try {
    Response response = await dio.post(
      path,
      data: payload.toJson(),
      options: Options(
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    final Map<String, dynamic> data = response.data;
    if (response.statusCode == 200) {
      // print("vendor reviews: $data");
      store.dispatch(GetAllVendorReviews(data['body']));
      result = Tuple2(1, data['message']);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');
      result = const Tuple2(2, "No Vendors");
    }
  } catch (e) {
    print('Review Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> updateVendor(UpdateVendorPayload payload) async {
  String path = '/api/UpdateVendorById?vendorId=${payload.vendorId}';

  var result = const Tuple2(0, "");
  try {
    Response response = await dio.post(
      path,
      data: payload.toJson(),
      options: Options(
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    final Map<String, dynamic> data = response.data;
    if (response.statusCode == 200) {
      print("vendor update: $data");
      // store.dispatch(GetAllVendorReviews(data['body']));
      result = Tuple2(1, data['message']);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');
      result = const Tuple2(2, "No Vendors");
    }
  } catch (e) {
    print('Update vendor Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> getVendorById(String vendorId) async {
  String path = '/api/GetVendorById?vendorId=$vendorId';

  var result = const Tuple2(0, "");
  try {
    Response response = await dio.get(
      path,
      options: Options(
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    final Map<String, dynamic> data = response.data;
    if (response.statusCode == 200) {
      // print("get vendor: ${data['body']}");
      store.dispatch(UpdateUserAction(data['body']));
      result = Tuple2(1, data['message']);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');
      result = const Tuple2(2, "No Vendors");
    }
  } catch (e) {
    print('Get vendor Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> getCommuterById(String commuterId) async {
  String path = '/api/GetCommuterById?commuterId=$commuterId';

  var result = const Tuple2(0, "");
  try {
    Response response = await dio.get(
      path,
      options: Options(
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    final Map<String, dynamic> data = response.data;
    if (response.statusCode == 200) {
      // print("get commuter: ${data['body']}");
      store.dispatch(UpdateUserAction(data['body']));
      result = Tuple2(1, data['message']);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');
      result = const Tuple2(2, "No Vendors");
    }
  } catch (e) {
    print('Get commuter Error: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> rateVendor(RateVendorPayload payload) async {
  String path = '/api/CommuterRateVendor';

  var result = const Tuple2(0, "");
  try {
    Response response = await dio.post(
      path,
      data: payload.toJson(),
      options: Options(
        validateStatus: (status) {
          return status != null &&
              status < 500; // Accept all status codes < 500
        },
      ),
    );

    final Map<String, dynamic> data = response.data;
    if (response.statusCode == 200) {
      print(data);
      // store.dispatch(GetAllVendors(data['body']));
      result = Tuple2(1, data['message']);
    } else {
      // Handle errors
      // print('Request failed with status: ${response.statusCode}');
      print('check error: $data');
      if (response.statusCode == 400) {
        result = const Tuple2(2, "Commuter can rate a vendor once");
      } else {
        result = const Tuple2(2, "Rating error");
      }
    }
  } catch (e) {
    print('Errorf: $e');
    result = const Tuple2(-1, "Network error");
  }
  return result;
}

Future<Tuple2<int, String>> uploadImgToDrive(UploadImagePayload payload) async {
  String path =
      '/api/UploadFileToGoogleDrive?userId=${payload.userId}&isVendor=${payload.isVendor}';
  var result = const Tuple2(0, "");

  try {
    String fileName = basename(payload.file.path);

    FormData formData = FormData.fromMap({
      "userId": payload.userId,
      "isVendor": payload.isVendor,
      "File":
          await MultipartFile.fromFile(payload.file.path, filename: fileName),
    });

    // print("response: ${formData.fields[1]}");

    Response response = await dio.post(
      path,
      data: formData,
      options: Options(
        headers: {
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    // print("response: ${response.data}");
    final Map<String, dynamic> data = response.data;

    if (response.statusCode == 200) {
      print("File uploaded successfully: ${response.data}");
      result = Tuple2(1, data['message']);
    } else {
      print("Failed to upload file: ${response.statusCode}");
      result = const Tuple2(2, "Upload image failed");
    }
  } catch (e) {
    print("Error uploading file: $e");
    result = const Tuple2(-1, "Network error");
  }

  return result;
}

void logoutFn() {
  try {
    store.dispatch(LogOut());
  } catch (e) {
    print('Error: $e');
  }
}

Future<TravelDetails> fetchTravelDetails(LatLng origin, LatLng destination,
    {String travelMode = "driving"}) async {
  final from = '${origin.latitude},${origin.longitude}';
  final to = '${destination.latitude},${destination.longitude}';
  // Change to 'walking', 'bicycling', or 'transit' as needed

  final url =
      '${matrixBaseUrl}origins=$from&destinations=$to&mode=$travelMode&key=$googleMapsApiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    DistanceMatrixResponse distanceMatrixResponse =
        DistanceMatrixResponse.fromJson(jsonResponse);

    // Extract the distance and duration
    final distance = distanceMatrixResponse.rows[0].elements[0].distance.text;
    final duration = distanceMatrixResponse.rows[0].elements[0].duration.text;

    // Return the results as a map
    return TravelDetails(
      distance: distance,
      time: duration,
    );
  } else {
    throw Exception('Failed to load travel details');
  }
}
