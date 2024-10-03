import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/subscription_perks_chart.dart';

class ManageSubscriptionScreen extends StatelessWidget {
  const ManageSubscriptionScreen({super.key});

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
                fit: BoxFit.cover)),
      ),
      Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.transparent,
            Color.fromARGB(128, 255, 255, 255),
            Colors.white
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
                  const Flexible(
                    child: const Text(
                      "Subscribe to Garden Buddy for more!",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: Colors.green,
                          fontFamily: "Khand",
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "By subscribing to Garden Buddy you will receive certain perks! A payment of \$3.99 recurs every month and automatically gets charged until cancellation. You can cancel your subscription of your app stores dashboard by clicking the cancel button below. You can cancel at anytime and your subscription will still be in effect until the next billing cycle where your perks will be removed and you will no longer be charge for the subscription Subscriptions to our service are not required. Feel free to contact us about any issues!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
            const Spacer(),
            const SubPerksChart(),
            // TODO: These buttons to be conditional later
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Open subscription prompt based on platform
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Subscribe for \$0.00",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Show user to subscriptions page based on platform
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
