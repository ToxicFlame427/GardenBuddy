import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/widgets/objects/subscription_perks_chart.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ManageSubscriptionScreen extends StatefulWidget {
  const ManageSubscriptionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ManageSubscriptionState();
  }
}

class _ManageSubscriptionState extends State<ManageSubscriptionScreen> {
  List<Package>? offers;

  Future fetchSubs(BuildContext context) async {
    final offerings = await PurchasesApi.fetchOffers();

    if (offerings.isEmpty) {
      print("No subscriptions found");
    } else {
      final offer = offerings.first;
      print("Offer: $offer");

      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      setState(() {
        offers = packages;
      });
    }
  }

  // Used to launch the prompt to purchase
  void makePurchase() async {
    await PurchasesApi.purchasePackage(offers![0]);
  }

  @override
  void initState() {
    fetchSubs(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      // Image object
      Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background_garden.jpg"),
          fit: BoxFit.cover,
        )),
      ),
      Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.transparent,
            Theme.of(context).cardColor.withAlpha(200),
            Theme.of(context).cardColor.withAlpha(128)
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
      ),
      SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "assets/icons/cross_mark.png",
                        width: 25,
                        height: 25,
                      )),
                  Flexible(
                    child: Text("Subscribe to Garden Buddy for more!",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                offers == null
                    ? "Please wait... fetching subscriptions"
                    : "By subscribing to Garden Buddy you will receive certain perks! A payment of ${offers![0].storeProduct.priceString} recurs every month and automatically gets charged until cancellation. You can cancel your subscription of your app stores dashboard by clicking the cancel button below. You can cancel at anytime and your subscription will still be in effect until the next billing cycle where your perks will be removed and you will no longer be charge for the subscription Subscriptions to our service are not required. Feel free to contact us about any issues!",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const Spacer(),
            const SubPerksChart(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: ElevatedButton(
                onPressed: !PurchasesApi.subStatus
                    ? () async {
                        makePurchase();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      offers == null
                          ? "Please wait..."
                          : !PurchasesApi.subStatus
                              ? "Subscribe for ${offers![0].storeProduct.priceString}/month"
                              : "You are already subscribed!",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: () {
                  // Open manage subscriptions page depending of the type of device
                  if (Platform.isAndroid) {
                    launchUrl(Uri.parse(
                        "https://play.google.com/store/account/subscriptions"));
                  } else {
                    launchUrl(Uri.parse(
                        'https://apps.apple.com/account/subscriptions'));
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Cancel subscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      )),
    ]));
  }
}
