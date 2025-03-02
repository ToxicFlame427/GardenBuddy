import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer.dart';
import 'package:garden_buddy/widgets/objects/gb_icon_text_field.dart';
import 'package:garden_buddy/widgets/loading/list_card_loading.dart';
import 'package:garden_buddy/widgets/lists/plant_list_card.dart';
import 'package:garden_buddy/widgets/objects/no_connection_widget.dart';
import 'package:garden_buddy/widgets/objects/server_unreachable.dart';
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
  bool? plantListIsLoaded = false;
  int currentPage = 1;

  getPlantList() async {
    GardenAPIServices.plantList = await GardenAPIServices.getPlantSpeciesList(
        "both", _searchBarController.text, currentPage);

    // Check and change according to the plant list
    // If an error occured during, retrieval then the value is null
    setState(() {
      if (GardenAPIServices.plantList != null) {
        if (GardenAPIServices.plantList!.status
            .toLowerCase()
            .contains("no data")) {
          plantListIsLoaded = false;
        } else {
          plantListIsLoaded = true;
        }
      } else {
        // This means there was an issue with the response, or the server could not be reached
        plantListIsLoaded = null;
      }
    });
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
    if (plantListIsLoaded != null) {
      if (!plantListIsLoaded! && GardenAPIServices.plantList == null) {
        getPlantList();
      }
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
                }),
            Visibility(
                visible: plantListIsLoaded != null ? plantListIsLoaded! : false,
                replacement: Expanded(
                  // Replace the loading shimmer with unreachable response..
                  //..if the server or site cannot be reached, there is probably a better way to handle this
                  child: plantListIsLoaded != null
                      ? ListView.builder(
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            return ListCardLoading();
                          })
                      : ServerUnreachable(),
                ),
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
                        "There are no results. \nTry searching by a similar name or change filter settings.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {
                  // Set the state to change the current page
                  currentPage -= 1;
                  // Get the plant list with the new page number
                  if(pageIsValid(0)){
                    // Get the plant list with the new page number
                    getPlantList();
                  } else {
                    print("Page cannot move further backward");
                  }
                },
                  child: Text(
                    "< Back"
                  )
                ),
                ElevatedButton(onPressed: () {
                  // Set the state to change the current page
                  currentPage += 1;
                  if(pageIsValid(1)){
                    // Get the plant list with the new page number
                    getPlantList();
                  } else {
                    print("Page cannot move further forward");
                  }
                },
                  child: Text(
                    "Forward >"
                  )
                ),
              ]
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

  /* This function is used to determine whether the page can go
  backwards or forwards based on the response it was given by the server*/
  bool pageIsValid(int direction){
    // 0 = backwards/subtracting 1
    // 1 = forward/adding 1
    
    if(direction == 1){
      // Check for forward movement
      if(currentPage < GardenAPIServices.plantList!.pages){
        // As long as the current page count is smaller than the total pages, allow forward movement
        return true;
      } else {
        return false;
      }
    } else {
      // Check for backward movement
      if(currentPage >= 1){
        // As long as the page count is larger than 1, the allow backwards movement
        return true;
      } else {
        return false;
      }
    }
  }
}
