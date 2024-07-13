import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fuel_dey_buyers/ReduxState/store.dart';
import 'package:fuel_dey_buyers/Screens/Splash/app_loading.dart';
import 'package:fuel_dey_buyers/Screens/Splash/onboarding.dart';
import 'package:fuel_dey_buyers/Screens/Splash/welcome.dart';
import 'package:fuel_dey_buyers/Screens/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    StoreProvider(
      store: store,
      child: const MyApp(),
    ),
  );
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
      },
    );
  }
}
