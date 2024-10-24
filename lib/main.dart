import 'package:flutter/material.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/screens/home_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Main app entry point
Future main() async {
  // Initialize mobile ads
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await PurchasesApi.init();

  runApp(MaterialApp(
    home: const HomeScreen(),
    theme: ThemeData(useMaterial3: true),
  ));
}
