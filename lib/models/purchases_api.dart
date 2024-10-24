import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesApi {
  static const _apiKey = "goog_cByUBxntCAXbKegCwKpwgvLDamA";

  static Future init() async {
    // ignore: deprecated_member_use
    await Purchases.setDebugLogsEnabled(true);
    // ignore: deprecated_member_use
    await Purchases.setup(_apiKey);
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
