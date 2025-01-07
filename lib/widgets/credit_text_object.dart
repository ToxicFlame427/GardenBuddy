import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/formatting/hyperlink.dart';

class CreditTextObject extends StatelessWidget {
  const CreditTextObject({
    super.key,
    required this.text,
    required this.imagePath,
    required this.linkText,
    required this.url
  });

  final String text;
  final String imagePath;
  final String linkText;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.end,
            overflow: TextOverflow.clip,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Image.asset(
              imagePath,
              width: 25,
              height: 25,
              fit: BoxFit.contain,
            ),
          ),
          Hyperlink(label: linkText, urlString: url)
        ],
      ),
    );
  }
}
