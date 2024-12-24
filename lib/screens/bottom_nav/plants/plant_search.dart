import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/perenual/plant_species_list.dart';
import 'package:garden_buddy/models/services/perenual_api_services.dart';
import 'package:garden_buddy/widgets/gb_icon_text_field.dart';
import 'package:garden_buddy/widgets/lists/list_card_loading.dart';
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
  PlantSpeciesList? plantList;
  bool plantListIsLoaded = false;

  getPlantList() async {
    plantList = await PerenualAPIServices.getPlantSpeciesList();

    // Check and change according to the plant list
    if (plantList != null) {
      setState(() {
        plantListIsLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // When loaded, immedialty attempt to fetch the species list
    print("Getting plant list...");
    if (!plantListIsLoaded) {
      getPlantList();
    }
  }

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
            // MARK: PUT PLANT SPECIES LIST HERE
            Visibility(
              visible: plantListIsLoaded,
              replacement: Expanded(
                  child: ListView.builder(
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return ListCardLoading();
                      }
                  )
              ),
              child: Expanded(
                child: ListView.builder(
                    itemCount: plantList?.data.length,
                    itemBuilder: (context, index) {
                      return PlantListCard(
                        plantName: plantList!.data[index].commonName,
                        scientificName:
                            plantList!.data[index].scientificName[0],
                        imageAddress:
                            plantList?.data[index].defaultImage?.smallUrl,
                        plantId: plantList!.data[index].id,
                      );
                    }),
              ),
            )
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
