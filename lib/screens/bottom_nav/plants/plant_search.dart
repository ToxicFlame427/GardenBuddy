import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/widgets/gb_icon_text_field.dart';
import 'package:garden_buddy/widgets/lists/plant_list_card.dart';
import 'package:garden_buddy/widgets/no_connection_widget.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class PlantSearch extends StatefulWidget {
  const PlantSearch({super.key});

  @override
  State<PlantSearch> createState() {
    return _PlantSearchState();
  }
}

class _PlantSearchState extends State<PlantSearch> {
  final _searchBarController = TextEditingController();

  // For network integrity
  bool networkIntegrity = checkConnectionIntegrity();
  final StreamController<SwipeRefreshState> _refreshController =
      StreamController<SwipeRefreshState>();

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return the appropriate widget based on connection status
    if (networkIntegrity) {
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
                      return const PlantListCard(
                          imageAddress:
                              "https://cdn.shopify.com/s/files/1/0148/1945/9126/files/Dill_flower.jpg",
                          plantName: "Dill",
                          scientificName: "Anethum graveolens",
                          plantId: 1);
                    }))
          ],
        ),
      );
    } else {
      return Stack(children: [
        NoConnectionWidget(),
        SwipeRefresh.adaptive(
          indicatorColor: Theme.of(context).colorScheme.primary,
          stateStream: _refreshController.stream,
          onRefresh: () async {
            await getConnectionTypes();

            setState(() {
              networkIntegrity = checkConnectionIntegrity();
              _refreshController.sink.add(SwipeRefreshState.hidden);
            });
          },
          children: [SizedBox(width: 100)],
        )
      ]);
    }
  }
}
