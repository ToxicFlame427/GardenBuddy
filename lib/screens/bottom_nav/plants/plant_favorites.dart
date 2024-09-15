import 'package:flutter/material.dart';

class FavoritePlants extends StatefulWidget {
  const FavoritePlants({super.key});

  @override
  State<FavoritePlants> createState() {
    return _FavoritePlantsState();
  }
}

class _FavoritePlantsState extends State<FavoritePlants> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("Favorite plants here")
      ],
    );
  }
}