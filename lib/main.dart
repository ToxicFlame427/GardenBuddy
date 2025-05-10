// Woke up in the morning traveling straight into the sun!
import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/screens/home_screen.dart';
import 'package:garden_buddy/screens/introduction/introduction_root.dart';
import 'package:garden_buddy/theming/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Just organizing initialization stuff
Future<void> initializeStuff() async {
  // Initialize mobile ads
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await PurchasesApi.init();

  // Add and remove this for testing and production purposes
  enableDeveloperMode();

  if (!developerModeEnabled) {
    // Check the current sub status, as internet connection is needed to use basically any part of the application
    PurchasesApi.subStatus = await PurchasesApi.checkSubStatus();
    PurchasesApi.subStatus = false;
  }

  // Initially fetch the favorite plants
  DbService.favoritePlantsList = await DbService.instance.getFavoritePlants();

  // Basically the mastermind of all of these day change operations
  setCountValues();

  // Fetch the connection types to ensure internet connection
  await getConnectionTypes();
}

// Main app entry point
Future main() async {
  await initializeStuff();
  bool introComplete = await checkIntroComplete();

  runApp(MaterialApp(
    home: introComplete ? HomeScreen() : IntroductionRoot(),
    // Theme data for the entire app both light and dark
    // MARK: Light Theme
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
          primary: ThemeColors.green2,
          secondary: ThemeColors.green1,
          tertiary: ThemeColors.green3,
          primaryContainer: ThemeColors.accentGray,
          scrim: Colors.black),
      textTheme: TextTheme(
          headlineLarge: TextStyle(
              color: ThemeColors.green2,
              fontSize: 30,
              fontFamily: "Khand",
              fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
              color: ThemeColors.green2,
              fontSize: 22,
              fontFamily: "Khand",
              fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(
              color: ThemeColors.teal1,
              fontSize: 18,
              fontFamily: "Khand",
              fontWeight: FontWeight.bold)),
      cardColor: ThemeColors.accentGray,
    ),

    // MARK: Dark theme
    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
          primary: ThemeColors.green1,
          secondary: ThemeColors.green2,
          tertiary: ThemeColors.green3,
          primaryContainer: ThemeColors.accentGrayDark,
          scrim: Colors.white),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            color: ThemeColors.green2,
            fontSize: 30,
            fontFamily: "Khand",
            fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(
            color: ThemeColors.green2,
            fontSize: 22,
            fontFamily: "Khand",
            fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(
            color: ThemeColors.teal1,
            fontSize: 18,
            fontFamily: "Khand",
            fontWeight: FontWeight.bold),
      ),
      cardColor: ThemeColors.accentGrayDark,
    ),
  ));
}
