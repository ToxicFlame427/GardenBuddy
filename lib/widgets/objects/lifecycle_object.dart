import 'package:flutter/material.dart';

class LifeCycleObject extends StatelessWidget {
  const LifeCycleObject(
      {super.key,
      required this.label,
      required this.valueRange,
      required this.valueUnit,
      required this.imageAsset});

  final String label;
  final String valueRange;
  final String valueUnit;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Image.asset(
              imageAsset,
              width: 50,
              height: 50,
            ),
            //VerticalRule(color: Theme.of(context).cardColor, width: 5)
          ],
        )
      ],
    );
  }
}
