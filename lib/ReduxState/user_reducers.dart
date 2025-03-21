import 'package:fuel_dey_buyers/ReduxState/actions.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:geolocator/geolocator.dart';

AppState userReducer(AppState state, dynamic action) {
  if (action is UpdateUserAction) {
    return state..user = action.newUser;
  }
  if (action is InitialiseEmail) {
    return state..email = action.email;
  }

  if (action is SaveUserToken) {
    return state..userToken = action.userToken;
  }

  if (action is SaveUserWallet) {
    return state..userWallet = action.userWallet;
  }

  if (action is GetAllVendors) {
    return state..allVendors = action.allVendors;
  }

  if (action is GetAllVendorReviews) {
    return state..allVendorReviews = action.allVendorReviews;
  }

  if (action is SaveUserLocation) {
    return state..userLocation = action.userLocation;
  }

  if (action is UpdateLastLoginTime) {
    return state..lastLoginTime = action.lastLoginTime;
  }

  if (action is UpdateUserType) {
    return state..userType = action.userType;
  }

  if (action is LogOut) {
    return AppState(
      email: "",
      user: {},
      userToken: {},
      userWallet: {},
      allVendors: [],
      allVendorReviews: [],
      lastLoginTime: DateTime.now(),
      userType: "",
      userLocation: Position(
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      ),
    );
  }

  return state;
}
