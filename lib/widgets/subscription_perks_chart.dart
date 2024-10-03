import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/vertical_rule.dart';

class SubPerksChart extends StatelessWidget {
  const SubPerksChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
          height: 230,
          decoration: BoxDecoration(
              color: const Color.fromARGB(160, 255, 255, 255),
              border: Border.all(color: Colors.black, width: 2),
              borderRadius: BorderRadius.circular(20)),
          child: Row(children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Perks",
                        style: TextStyle(
                          fontFamily: "Khand",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
                    ),
                    Text("Access to all plant data",),
                    Text("Access to all disease data"),
                    Text("No advertisements"),
                    Text("Unlimited identifications"),
                    Text("Unlimited health assessments"),
                    Text("Unlimited Gardn AI prompts")
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
                      const Text(
                        "Free",
                        style: TextStyle(
                          fontFamily: "Khand",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                        ),
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Paid",
                          style: TextStyle(
                            fontFamily: "Khand",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                          ),
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
