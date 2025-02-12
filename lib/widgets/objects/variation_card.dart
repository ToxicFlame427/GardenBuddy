import 'package:flutter/material.dart';

class VariationCard extends StatelessWidget {
  const VariationCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // irst, detwrmine the color of the card based on the label given
    Color cardColor = Theme.of(context).colorScheme.primary;

    // "Species" and "Variety" will both be the default green color
    switch(label)
    {
      case "Perennial":
        cardColor = Colors.blue;
        break;
      case "Annual":
        cardColor = Colors.purple;
        break;
      case "Biennial":
        // TODO: Setup color
        break;
      default:
        cardColor = Theme.of(context).colorScheme.primary;
        break;
    }

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12
          ),
        ),
      ),
    );
  }
}
