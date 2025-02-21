import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/loading/list_card_loading.dart';

class PlantIdLoading extends StatelessWidget {
  const PlantIdLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          return ListCardLoading();
        }
      )
    );
  }
}