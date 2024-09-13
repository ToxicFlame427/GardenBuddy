import 'package:flutter/material.dart';
import 'package:garden_buddy/screens/home_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Main app entry point
void main() {
  // Initialize mobile ads
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}
