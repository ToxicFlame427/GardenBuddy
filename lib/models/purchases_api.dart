import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesApi {
  static const _googleApiKey = "goog_cByUBxntCAXbKegCwKpwgvLDamA";
  static const _appleApiKey = "appl_CLNGGUFetZSXpyQtIKfzhoQcMNq";

  static Future init() async {
    // ignore: deprecated_member_use
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration config = PurchasesConfiguration(Platform.isAndroid ? _googleApiKey : _appleApiKey);
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
      // Purchase was successful
      return true;
    } catch (e) {
      // Purchase did not occur
      return false;
    }
  }
}
