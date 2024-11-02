import 'package:flutter/material.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/screens/home_screen.dart';
import 'package:garden_buddy/theming/colors.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Main app entry point
Future main() async {
  // Initialize mobile ads
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await PurchasesApi.init();

  runApp(MaterialApp(
    home: const HomeScreen(),
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: ThemeColors.green2,
        secondary: ThemeColors.green1,
        tertiary: ThemeColors.green3,
        primaryContainer: ThemeColors.accentGray,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: ThemeColors.green2,
          fontSize: 30,
          fontFamily: "Khand",
          fontWeight: FontWeight.bold
        ),
        headlineMedium: TextStyle(
          color: ThemeColors.green2,
          fontSize: 22,
          fontFamily: "Khand",
          fontWeight: FontWeight.bold
        )
      ),
      cardColor: ThemeColors.accentGray,
    ),

    darkTheme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: ThemeColors.green1,
        secondary: ThemeColors.green2,
        tertiary: ThemeColors.green3,
        primaryContainer: ThemeColors.accentGrayDark,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: ThemeColors.green2,
          fontSize: 30,
          fontFamily: "Khand",
          fontWeight: FontWeight.bold
        ),
        headlineMedium: TextStyle(
          color: ThemeColors.green2,
          fontSize: 22,
          fontFamily: "Khand",
          fontWeight: FontWeight.bold
        )
      ),
      cardColor: ThemeColors.accentGrayDark,
    ),
  ));
}
