import 'package:flutter/material.dart';
import 'package:garden_buddy/theming/colors.dart';
import 'package:garden_buddy/widgets/formatting/lifecycle_object.dart';

class FiveWayMeter extends StatelessWidget {
  const FiveWayMeter(
      {super.key,
      required this.value,
      required this.label,
      required this.onInfoTap});

  final int value;
  final String label;
  final Function onInfoTap;

  @override
  Widget build(BuildContext context) {
    final Widget? meter;

    if (value == 1) {
      meter = _ThreeWayMeterText(text: "Very low");
    } else if (value == 2) {
      meter = _ThreeWayMeterText(text: "Low");
    } else if (value == 3) {
      meter = _ThreeWayMeterText(text: "Medium");
    } else if (value == 4) {
      meter = _ThreeWayMeterText(text: "High");
    } else if (value == 5) {
      meter = _ThreeWayMeterText(text: "Very High");
    } else {
      meter = _ThreeWayMeterText(text: "Unknown");
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 35,
                    height: 12,
                    child: ColoredBox(
                        color: value > 0
                            ? Colors.green
                            : Theme.of(context).cardColor),
                  ),
                  SizedBox(
                    width: 35,
                    height: 12,
                    child: ColoredBox(
                        color: value > 1
                            ? Colors.lime
                            : Theme.of(context).cardColor),
                  ),
                  SizedBox(
                    width: 35,
                    height: 12,
                    child: ColoredBox(
                        color: value > 2
                            ? Colors.yellow
                            : Theme.of(context).cardColor),
                  ),
                  SizedBox(
                    width: 35,
                    height: 12,
                    child: ColoredBox(
                        color: value > 3
                            ? Colors.orange
                            : Theme.of(context).cardColor),
                  ),
                  SizedBox(
                    width: 35,
                    height: 12,
                    child: ColoredBox(
                        color: value > 4
                            ? Colors.red
                            : Theme.of(context).cardColor),
                  ),
                  // Display the correct meter text based on the number provided
                  meter
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
              IconButton(
                  onPressed: () {
                    onInfoTap();
                  },
                  icon: Icon(Icons.info),
                  color: ThemeColors.teal1,
                  iconSize: 20,
              ),
              Text(
                label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ])
          ],
        ),
      ),
    );
  }
}

class _ThreeWayMeterText extends StatelessWidget {
  const _ThreeWayMeterText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 12),
      ),
    );
  }
}
