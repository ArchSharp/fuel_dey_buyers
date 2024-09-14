import 'package:fuel_dey_buyers/Model/user.dart';
import 'package:fuel_dey_buyers/ReduxState/user_reducers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class AppState {
  late Map<String, dynamic> user;
  late Map<String, dynamic> userToken;
  late Map<String, dynamic> userWallet;
  late String email;
  late List<Vendor> allVendors;
  late List<dynamic> allVendorReviews;
  late Position userLocation;

  AppState({
    required this.email,
    required this.user,
    required this.userToken,
    required this.userWallet,
    required this.allVendors,
    required this.allVendorReviews,
    required this.userLocation,
  });
}

// Combine your reducers into a single reducer
final combinedReducers = combineReducers<AppState>([userReducer]);

// Create the Redux store
final Store<AppState> store = Store<AppState>(
  combinedReducers,
  initialState: AppState(
    email: '',
    user: {},
    userToken: {},
    userWallet: {},
    allVendors: [],
    allVendorReviews: [],
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
  ),
);
