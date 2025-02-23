import 'package:flutter/material.dart';

class ExtraInfoRow extends StatelessWidget {
  const ExtraInfoRow({super.key, required this.label, required this.data});

  final String label;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(width: 10,),
        Text(data),
      ],
    );
  }
}
