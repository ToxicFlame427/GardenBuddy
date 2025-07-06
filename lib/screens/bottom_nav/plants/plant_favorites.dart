import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/dialogs/loading_dialog.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';
import 'package:garden_buddy/widgets/lists/plant_list_card.dart';
import 'package:garden_buddy/widgets/objects/no_favorites.dart';

class FavoritePlants extends StatefulWidget {
  const FavoritePlants({super.key});

  @override
  State<FavoritePlants> createState() {
    return _FavoritePlantsState();
  }
}

class _FavoritePlantsState extends State<FavoritePlants> {
  bool favoritesUpdated = false;
  List<PlantSpeciesDetails> convertedList = [];
  bool _isLoading = true;
  int currentPage = 1;
  int itemsPerPage = 10;
  int maxPages = 1;

  @override
  void initState() {
    // If the box does not exist or the list is empty, return an empty list
    // When the init state is changed, always get an updated favorites list
    if (!favoritesUpdated) {
      _loadFavorites();
    }

    super.initState();
  }

  /* This function is used to determine whether the page can go
  backwards or forwards based on the response it was given by the server*/
  bool pageIsValid(int direction) {
    // 0 = backwards/subtracting 1
    // 1 = forward/adding 1

    if (direction == 1) {
      // Check for forward movement
      if (currentPage < maxPages) {
        // As long as the current page count is smaller than the total pages, allow forward movement
        return true;
      } else {
        return false;
      }
    } else {
      // Check for backward movement
      if (currentPage > 1) {
        // As long as the page count is larger than 1, the allow backwards movement
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> _loadFavorites() async {
    if (!mounted) return; // Avoid calling setState if the widget is disposed

    setState(() {
      _isLoading = true;
      currentPage = 1;
    });

    // This line internally updates DbService.favoritePlantsList as per your DbService logic
    await DbService.instance.getFavoritePlants();

    // Create a temporary list for the conversion
    List<PlantSpeciesDetails> tempConvertedList = [];
    for (int i = 0; i < DbService.favoritePlantsList.length; i++) {
      // Ensure DbService.favoritePlantsList[i] and its jsonContent are valid
      try {
        PlantSpeciesDetails detail = PlantSpeciesDetails.fromRawJson(
            DbService.favoritePlantsList[i].jsonContent);

        // Replace URL with local image path if available
        if (detail.data.images.isNotEmpty) {
          detail.data.images[0].url =
              DbService.favoritePlantsList[i].localImageDir;
        }
        tempConvertedList.add(detail);
      } catch (e) {
        debugPrint(
            "Error converting plant data: ${DbService.favoritePlantsList[i].name} - $e");
      }
    }

    if (mounted) {
      setState(() {
        convertedList = tempConvertedList;
        convertedList = convertedList.reversed.toList();
        _isLoading = false;
        maxPages = (convertedList.length / 10).ceil();
        debugPrint("Pages: $maxPages");
      });
    }
  }

  void _navigateToPlantViewer(PlantSpeciesDetails plantDetails) async {
    // Await the result from PlantSpeciesViewer
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => PlantSpeciesViewer(
          plantName: plantDetails.data.name,
          apiId: plantDetails.data.apiId,
          offlineDetails: plantDetails,
        ),
      ),
    );

    // Check if the result indicates a change and the widget is still mounted
    if (result == true && mounted) {
      // If favorites were changed, reload the list
      _loadFavorites();
    }
  }

  void showDeletionDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return ConfirmationDialog(
              title: "Clear favorites?",
              description:
                  "This is how you can completly delete all of your favorite plants. If you only want to delete one plant, tap on the plant card, then tap on the red heart in the top corner to remove the plant. NOTE: After clearing your favorite plants list, this data connot be recovered. Are you sure you want to do completely wipe your favorites list?",
              imageAsset: "assets/icons/icon.jpg",
              positiveButtonText: "Clear",
              negativeButtonText: "No",
              onNegative: () {
                Navigator.pop(ctx);
              },
              onPositive: () {
                Navigator.pop(ctx);
                initFavoritesNuke();
              });
        });
  }

  void initFavoritesNuke() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return LoadingDialog(loadingText: "Clearing favorites...");
        });

    await DbService.instance.nukeFavoritesTable();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop();

      setState(() {
        DbService.favoritePlantsList = [];
        _loadFavorites();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Calculate start and end index for the current page
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    if (endIndex > convertedList.length) {
      endIndex = convertedList.length;
    }

    List<PlantSpeciesDetails> currentPageItems =
        convertedList.sublist(startIndex, endIndex);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(children: [
        Column(
          children: [
            if (DbService.favoritePlantsList.isNotEmpty)
              Text(
                "Your favorited plants will show up here and can be accessed without an internet connection.",
                style:
                    TextStyle(fontSize: 14, color: Colors.grey, height: 0.90),
                textAlign: TextAlign.center,
              ),
            Expanded(
                child: DbService.favoritePlantsList.isNotEmpty
                    ?
                    // Responsive design targeting tablets
                    Stack(children: [
                        Responsive(
                          phone: ListView.builder(
                              itemCount: currentPageItems.length,
                              itemBuilder: (context, index) {
                                try {
                                  return PlantListCard(
                                    plantName:
                                        currentPageItems[index].data.name,
                                    scientificName: currentPageItems[index]
                                        .data
                                        .scientificName,
                                    // Handle a local image address rather than a network image
                                    imageAddress: currentPageItems[index]
                                            .data
                                            .images
                                            .isEmpty
                                        ? null
                                        : currentPageItems[index]
                                            .data
                                            .images[0]
                                            .url,
                                    plantId: currentPageItems[index].data.apiId,
                                    onTapAction: () {
                                      _navigateToPlantViewer(
                                          convertedList[index]);
                                    },
                                  );
                                } catch (e) {
                                  return SizedBox();
                                }
                              }),
                          // TODO: Fix this to use the page system as well!
                          tablet: GridView.builder(
                              itemCount: 20,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, mainAxisExtent: 120),
                              itemBuilder: (context, index) {
                                return PlantListCard(
                                  plantName: convertedList[index].data.name,
                                  scientificName:
                                      convertedList[index].data.scientificName,
                                  // Handle a local image address rather than a network image
                                  imageAddress: convertedList[index]
                                          .data
                                          .images
                                          .isEmpty
                                      ? null
                                      : convertedList[index].data.images[0].url,
                                  plantId: convertedList[index].data.apiId,
                                  onTapAction: () {
                                    _navigateToPlantViewer(
                                        convertedList[index]);
                                  },
                                );
                              }),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FloatingActionButton(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      showDeletionDialog();
                                    })
                              ],
                            )
                          ],
                        ),
                      ])
                    : NoFavorites()),
            maxPages > 1
                ?
                // Buttons
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                        pageIsValid(0)
                            ? ElevatedButton(
                                onPressed: () {
                                  if (pageIsValid(0)) {
                                    setState(() {
                                      currentPage -= 1;
                                    });
                                  } else {
                                    debugPrint(
                                        "Page cannot move further backward");
                                  }
                                },
                                child: Text("< Back"))
                            : SizedBox(),
                        Padding(
                          padding: EdgeInsets.all(
                              GardenAPIServices.plantList!.pages == 1
                                  ? GardenAPIServices.plantsListLength
                                      .toDouble()
                                  : 0),
                          child: Text("Page $currentPage of $maxPages"),
                        ),
                        pageIsValid(1)
                            ? ElevatedButton(
                                onPressed: () {
                                  // Set the state to change the current page
                                  if (pageIsValid(1)) {
                                    setState(() {
                                      currentPage += 1;
                                    });
                                  } else {
                                    debugPrint(
                                        "Page cannot move further forward");
                                  }
                                },
                                child: Text("Forward >"))
                            : SizedBox()
                      ])
                : SizedBox()
          ],
        ),
      ]),
    );
  }
}
