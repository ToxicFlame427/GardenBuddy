import 'package:flutter/material.dart';

class NoFavorites extends StatelessWidget {
  const NoFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.favorite_border,
          size: 100,
          color: Colors.red,
        ),
        Text(
          "It looks like you have no favorite plants.\nAdd some through our plant search!",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
