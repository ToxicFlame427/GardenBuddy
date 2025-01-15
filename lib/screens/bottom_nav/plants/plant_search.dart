import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer.dart';
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
  bool plantListIsLoaded = false;

  getPlantList() async {
    GardenAPIServices.plantList = await GardenAPIServices.getPlantSpeciesList(
        "both", _searchBarController.text);

    // Check and change according to the plant list
    if (GardenAPIServices.plantList != null) {
      setState(() {
        plantListIsLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // If the plant list is not null, then loading is already complete
    if (GardenAPIServices.plantList != null) {
      setState(() {
        plantListIsLoaded = true;
      });
    }

    // When loaded, immedialty attempt to fetch the species list
    if (!plantListIsLoaded && GardenAPIServices.plantList == null) {
      print("Getting plant list...");
      getPlantList();
    } else {
      print("Plant list already persists, show list.");
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
                onPressed: () async {
                  // Before doing anything, reset the list to being null
                  setState(() {
                    plantListIsLoaded = false;
                    GardenAPIServices.plantList = null;
                  });

                  // After the state is called, then try to load a new request with the new query
                  getPlantList();
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
                        })),
                child: GardenAPIServices.plantList?.data.isNotEmpty ?? true
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: GardenAPIServices.plantList?.data.length,
                            itemBuilder: (context, index) {
                              return PlantListCard(
                                plantName: GardenAPIServices
                                    .plantList!.data[index].name,
                                scientificName: GardenAPIServices
                                    .plantList!.data[index].scientificName,
                                imageAddress: GardenAPIServices
                                        .plantList!.data[index].images.isEmpty
                                    ? null
                                    : GardenAPIServices
                                        .plantList?.data[index].images[0].url,
                                plantId: GardenAPIServices
                                    .plantList!.data[index].apiId,
                                onTapAction: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => PlantSpeciesViewer(
                                              plantName: GardenAPIServices
                                                  .plantList!.data[index].name,
                                              apiId: GardenAPIServices
                                                  .plantList!
                                                  .data[index]
                                                  .apiId)));
                                },
                              );
                            }),
                      )
                    // If the list is empty, show the user that there are no search/filter results
                    : Expanded(
                        child: Center(
                            child: Text(
                        "There are no results! \nTry searching by a similar name or change filter settings.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.scrim),
                      ))))
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
