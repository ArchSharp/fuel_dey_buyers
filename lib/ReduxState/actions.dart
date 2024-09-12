import 'package:geolocator/geolocator.dart';

class UpdateUserAction {
  final Map<String, dynamic> newUser;

  UpdateUserAction(this.newUser);
}

class InitialiseEmail {
  final String email;

  InitialiseEmail(this.email);
}

class LogOut {
  LogOut();
}

class SaveUserToken {
  final Map<String, dynamic> userToken;

  SaveUserToken(this.userToken);
}

class SaveUserWallet {
  final Map<String, dynamic> userWallet;

  SaveUserWallet(this.userWallet);
}

class GetAllVendors {
  final List<dynamic> allVendors;

  GetAllVendors(this.allVendors);
}

class GetAllVendorReviews {
  final List<dynamic> allVendorReviews;

  GetAllVendorReviews(this.allVendorReviews);
}

class SaveUserLocation {
  final Position userLocation;

  SaveUserLocation(this.userLocation);
}
