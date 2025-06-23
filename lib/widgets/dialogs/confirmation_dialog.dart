import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.imageAsset,
      required this.positiveButtonText,
      required this.negativeButtonText,
      required this.onNegative,
      required this.onPositive});

  final String title;
  final String description;
  final String imageAsset;
  // Button style changes based on positive text. If positive button is "Reset", the style will change
  final String positiveButtonText;
  final String negativeButtonText;
  final void Function() onNegative;
  final void Function() onPositive;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)), //this right here
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    imageAsset,
                    width: 60,
                    height: 60,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(title,
                      style: Theme.of(context).textTheme.headlineMedium),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text(description),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primary)),
                    onPressed: onNegative,
                    child: Text(
                      negativeButtonText,
                      style: const TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            positiveButtonText == "Reset" ? Theme.of(context).cardColor : Theme.of(context).colorScheme.primary)),
                    onPressed: onPositive,
                    child: Text(
                      positiveButtonText,
                      style: TextStyle(color: positiveButtonText == "Reset" ? Colors.red : Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
