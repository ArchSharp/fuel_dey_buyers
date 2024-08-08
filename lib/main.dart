import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_forgotpassword.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signin.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_signup.dart';
import 'package:fuel_dey_buyers/Screens/Auths/reset_password.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_forgotpassword.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signin.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_signup.dart';
import 'package:fuel_dey_buyers/Screens/Auths/commuter_verify_email.dart';
import 'package:fuel_dey_buyers/Screens/Auths/vendor_verify_email.dart';
import 'package:fuel_dey_buyers/Screens/Main/search.dart';
import 'package:fuel_dey_buyers/Screens/Main/vendor_home.dart';
import 'package:fuel_dey_buyers/Screens/Splash/app_loading.dart';
import 'package:fuel_dey_buyers/Screens/Splash/logo_splash.dart';
import 'package:fuel_dey_buyers/Screens/Splash/onboarding.dart';
import 'package:fuel_dey_buyers/Screens/Splash/welcome.dart';
import 'package:fuel_dey_buyers/Screens/Main/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool permissionGranted = await checkLocationPermission();
  print(permissionGranted); // Will print the current permission status

  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      StoreProvider(
        store: store,
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black, // Optional: Adjust text color if needed
          displayColor: Colors.black,
        ),
      ),
      routes: {
        Home.routeName: (ctx) => const Home(),
        Onboarding.routeName: (ctx) => const Onboarding(),
        Welcome.routeName: (ctx) => const Welcome(),
        VendorSignup.routeName: (ctx) => const VendorSignup(),
        VendorSignin.routeName: (ctx) => const VendorSignin(),
        VendorForgotpassword.routeName: (ctx) => const VendorForgotpassword(),
        VendorVerifyEmail.routeName: (ctx) => const VendorVerifyEmail(),
        CommuterSignup.routeName: (ctx) => const CommuterSignup(),
        CommuterSignin.routeName: (ctx) => const CommuterSignin(),
        CommuterForgotpassword.routeName: (ctx) =>
            const CommuterForgotpassword(),
        CommuterVerifyEmail.routeName: (ctx) => const CommuterVerifyEmail(),
        ResetPassword.routeName: (ctx) => const ResetPassword(),
        Search.routeName: (ctx) => const Search(),
        VendorHome.routeName: (ctx) => const VendorHome(),
        LogoSplash.routeName: (ctx) => const LogoSplash(),
      },
    );
  }
}

Future<bool> checkLocationPermission() async {
  var status = await Permission.location.status;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (status.isGranted) {
    // Permission is granted, you can update SharedPreferences here
    await prefs.setBool('location_permission_granted', true);
    return true;
  } else {
    // Permission is not granted, update SharedPreferences
    await prefs.setBool('location_permission_granted', false);
    return false;
  }
}
