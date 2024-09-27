import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/gb_icon_text_field.dart';
import 'package:garden_buddy/widgets/lists/plant_list_card.dart';

class PlantSearch extends StatefulWidget {
  const PlantSearch({super.key});

  @override
  State<PlantSearch> createState() {
    return _PlantSearchState();
  }
}

class _PlantSearchState extends State<PlantSearch> {
  final _searchBarController = TextEditingController();

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GbIconTextfield(
              hint: "Search plants",
              controller: _searchBarController,
              icon: Icons.search,
              onPressed: () {
                print(_searchBarController.text);
              }),
          Expanded(
            child: ListView.builder(
                itemCount: 7,
                itemBuilder: (ctx, index) {
                  return const PlantListCard(imageAddress: "https://cdn.shopify.com/s/files/1/0148/1945/9126/files/Dill_flower.jpg", plantName: "Dill", scientificName: "Anethum graveolens", plantId: 1);
                }
            )
          )
        ],
      ),
    );
  }
}
