import 'package:flutter/material.dart';

class VariationCard extends StatelessWidget {
  const VariationCard({super.key, required this.label, required this.onTap, this.isPatent});

  final String label;
  final Function onTap;
  final bool? isPatent;

  @override
  Widget build(BuildContext context) {
    // irst, detwrmine the color of the card based on the label given
    Color cardColor = Theme.of(context).colorScheme.primary;

    // "Species" and "Variety" will both be the default green color
    if (isPatent != null) {
      // If isPatent is not null, then there is a patent, handle the label accordingly
      cardColor = Colors.red;
    } else {
      if (label.contains("Perennial")) {
        cardColor = Colors.blue;
      } else if (label.contains("Annual")) {
        cardColor = Colors.purple;
      } else if (label.contains("Biennial")) {
        cardColor = Colors.orange;
      } else {
        cardColor = Theme.of(context).colorScheme.primary;
      }
    }

    return TapRegion(
      onTapInside: (event) => onTap(),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 2, 16, 2),
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
