import 'package:flutter/material.dart';

class CustomInfoDialog extends StatelessWidget {
  const CustomInfoDialog(
      {super.key,
      required this.title,
      required this.description,
      required this.imageAsset,
      required this.buttonText,
      required this.onClose});

  final String title;
  final String description;
  final String imageAsset;
  final String buttonText;
  final void Function() onClose;

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
                  child: Text(
                    title,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary)),
                    onPressed: onClose,
                    child: Text(
                      buttonText,
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
