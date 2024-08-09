import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

String? baseUrl = dotenv.env['BASE_URL'];

Future<Tuple2<int, String>> signInVendorFn(UserSignInPayload payload) async {
  String apiUrl = '$baseUrl/api/SignInVendor';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

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
    "Authorization": "Bearer YOUR_API_KEY",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

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
    "Authorization": "Bearer YOUR_API_KEY",
  };

  // print(payload);

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload.toJson()));

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

Future<Tuple2<int, String>> vendorsignupFn(VendorSignUpPayload payload) async {
  String apiUrl = '$baseUrl/api/NewVendor';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_API_KEY",
  };

  // print(payload);

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload.toJson()));

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
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {"email": email, "otp": otp};

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

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
    "Authorization": "Bearer YOUR_API_KEY",
  };

  final Map<String, dynamic> payload = {"email": email};

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload));

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
    "Authorization": "Bearer YOUR_API_KEY",
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

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
    "Authorization": "Bearer YOUR_API_KEY",
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
        headers: headers, body: json.encode(payload));

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

Future<Tuple2<int, String>> getAllVendors(GetAllVendorsPayload payload) async {
  String apiUrl = '$baseUrl/api/CommuterGetAllVendors';
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": 'Bearer ${store.state.userToken["accesstoken"]}',
  };

  var result = const Tuple2(0, "");
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: json.encode(payload.toJson()));

    final Map<String, dynamic> data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(data);
      store.dispatch(GetAllVendors(data['body']));
      result = Tuple2(1, data['message']);
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
    print('Error: $e');
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
