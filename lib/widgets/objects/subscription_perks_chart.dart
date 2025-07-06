import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/formatting/vertical_rule.dart';

class SubPerksChart extends StatelessWidget {
  const SubPerksChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 260,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withAlpha(175),
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(20)),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Perks",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const Text(
                    "Access to all plant data",
                  ),
                  //const Text("Access to all disease data"),
                  const Text("No advertisements"),
                  const Text("Unlimited identifications"),
                  const Text("Unlimited health assessments"),
                  const Text("Unlimited Garden AI prompts"),
                  //const Text("Save AI chats for later"),
                  const Text("Save IDs and HAs")
                ],
              ),
            ),
          ),
          const VerticalRule(color: Colors.black, width: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Free",
                      style: Theme.of(context).textTheme.headlineMedium),
                  Image.asset(
                    "assets/icons/check_mark.png",
                    height: 24,
                    width: 24,
                  ),
                  // Image.asset(
                  //   "assets/icons/check_mark.png",
                  //   height: 24,
                  //   width: 24,
                  // ),
                  Image.asset(
                    "assets/icons/cross_mark.png",
                    height: 24,
                    width: 24,
                  ),
                  Image.asset(
                    "assets/icons/cross_mark.png",
                    height: 24,
                    width: 24,
                  ),
                  Image.asset(
                    "assets/icons/cross_mark.png",
                    height: 24,
                    width: 24,
                  ),
                  Image.asset(
                    "assets/icons/cross_mark.png",
                    height: 24,
                    width: 24,
                  ),
                  // Image.asset(
                  //   "assets/icons/cross_mark.png",
                  //   height: 24,
                  //   width: 24,
                  // ),
                  Image.asset(
                    "assets/icons/cross_mark.png",
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Sub",
                        style: Theme.of(context).textTheme.headlineMedium),
                    Image.asset(
                      "assets/icons/check_mark.png",
                      height: 24,
                      width: 24,
                    ),
                    // Image.asset(
                    //   "assets/icons/check_mark.png",
                    //   height: 24,
                    //   width: 24,
                    // ),
                    Image.asset(
                      "assets/icons/check_mark.png",
                      height: 24,
                      width: 24,
                    ),
                    Image.asset(
                      "assets/icons/check_mark.png",
                      height: 24,
                      width: 24,
                    ),
                    Image.asset(
                      "assets/icons/check_mark.png",
                      height: 24,
                      width: 24,
                    ),
                    Image.asset(
                      "assets/icons/check_mark.png",
                      height: 24,
                      width: 24,
                    ),
                    // Image.asset(
                    //   "assets/icons/check_mark.png",
                    //   height: 24,
                    //   width: 24,
                    // ),
                    Image.asset(
                      "assets/icons/check_mark.png",
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
