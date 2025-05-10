import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/dialogs/loading_dialog.dart';
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

  Future<void> _loadFavorites() async {
    if (!mounted) return; // Avoid calling setState if the widget is disposed

    setState(() {
      _isLoading = true;
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
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // If the box does not exist or the list is empty, return an empty list
    // When the init state is changed, always get an updated favorites list
    if (!favoritesUpdated) {
      _loadFavorites();
    }

    super.initState();
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

    await DbService.instance.nukeDatabase();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop();

      setState(() {
        DbService.instance.resetValues();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Put the array in reverse order, so the most recent ones will be at the top
    convertedList = convertedList.reversed.toList();

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

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
                    ? ListView.builder(
                        itemCount: DbService.favoritePlantsList.length,
                        itemBuilder: (context, index) {
                          return PlantListCard(
                            plantName: convertedList[index].data.name,
                            scientificName:
                                convertedList[index].data.scientificName,
                            // Handle a local image address rather than a network image
                            imageAddress:
                                convertedList[index].data.images.isEmpty
                                    ? null
                                    : convertedList[index].data.images[0].url,
                            plantId: convertedList[index].data.apiId,
                            onTapAction: () {
                              _navigateToPlantViewer(convertedList[index]);
                            },
                          );
                        })
                    : NoFavorites())
          ],
        ),
        // This widgets just places the action button in the bottom corner
        if (DbService.favoritePlantsList.isNotEmpty)
          // Only show the clear button if the list is not empty
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Icon(
                        Icons.delete,
                        size: 32,
                      ),
                      onPressed: () {
                        showDeletionDialog();
                      })
                ],
              )
            ],
          ),
      ]),
    );
  }
}
