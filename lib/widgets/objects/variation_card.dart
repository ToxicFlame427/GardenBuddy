import 'package:flutter/material.dart';

class VariationCard extends StatelessWidget {
  const VariationCard({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // irst, detwrmine the color of the card based on the label given
    Color cardColor = Theme.of(context).colorScheme.primary;

    // "Species" and "Variety" will both be the default green color
    if(label.contains("Perennial")){
      cardColor = Colors.blue;
    } else if (label.contains("Annual")){
      cardColor = Colors.purple;
    } else if (label.contains("Biennial")){
      cardColor = Colors.amber;
    } else {
      cardColor = Theme.of(context).colorScheme.primary;
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
