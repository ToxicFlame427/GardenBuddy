import 'dart:io';

import 'package:flutter/services.dart';
import 'package:garden_buddy/keys.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesApi {
  static bool subStatus = false;

  static Future init() async {
    // ignore: deprecated_member_use
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration config = PurchasesConfiguration(
        Platform.isAndroid ? Keys.googleApiKey : Keys.appleApiKey);
    await Purchases.configure(config);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offers = await Purchases.getOfferings();
      final current = offers.current;

      return current == null ? [] : [current];
    } on PlatformException catch (e) {
      print(e.message);
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      // MARK: Purchase was successful
      subStatus = await checkSubStatus();
      return true;
    } catch (e) {
      // MARK: Purchase did not occur or failed
      subStatus = false;
      return false;
    }
  }

  // NOT SURE IF THIS WILL WORK, MORE TESTING IS NEEDED
  // JK, it works pretty well, but a connection to the app is always needed to get a response
  static Future<bool> checkSubStatus() async {
    bool subActive = false;

    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all["All Access"]!.isActive) {
        // MARK: Grant the user unlimited access
        subActive = true;
      }
    } catch (e) {
      // Error getting customer information
      subActive = false;
    }

    print("Is sub active $subActive");
    return subActive;
  }
}
