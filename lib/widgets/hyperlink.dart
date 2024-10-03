import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Hyperlink extends StatelessWidget {
  const Hyperlink({super.key, required this.label, required this.urlString});

  final String label;
  final String urlString;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(urlString)),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blue
          ),
        ),
      ),
    );
  }
}
