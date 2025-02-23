import 'package:flutter/material.dart';

class LifeCycleObject extends StatelessWidget {
  const LifeCycleObject(
      {super.key,
      required this.label,
      required this.imageAsset,
      required this.content});

  final String label;
  final String imageAsset;
  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  imageAsset,
                  width: 35,
                  height: 35,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.headlineSmall,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: content
            )
            //VerticalRule(color: Theme.of(context).cardColor, width: 5)
          ],
        )
      ],
    );
  }
}
