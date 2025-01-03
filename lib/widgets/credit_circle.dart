import 'package:flutter/material.dart';
import 'package:garden_buddy/models/purchases_api.dart';

class CreditCircle extends StatelessWidget {
  const CreditCircle({super.key, required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade500,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 0, 9, 0),
          child: Text(
            PurchasesApi.subStatus ? "\u221E" : value.toString(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
