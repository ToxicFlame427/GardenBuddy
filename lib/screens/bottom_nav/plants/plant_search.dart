import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/gb_icon_text_field.dart';
import 'package:garden_buddy/widgets/lists/list_card_loading.dart';

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
      padding: const EdgeInsets.all(10),
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
                  return const ListCardLoading();
                }),
          )
        ],
      ),
    );
  }
}
