import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
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

  void asyncGetFavs() async {
    if (DbService.favoritePlantsList.isEmpty) {
      DbService.favoritePlantsList =
          await DbService.instance.getFavoritePlants();
    }

    setState(() {
      favoritesUpdated = true;
    });
  }

  void convertList() {
    // Convert the items to the correct format so they are usable
    for (int i = 0; i < DbService.favoritePlantsList.length; i++) {
      convertedList.add(PlantSpeciesDetails.fromRawJson(
          DbService.favoritePlantsList[i].jsonContent));
    }
  }

  @override
  void initState() {
    // If the box does not exist or the list is empty, return an empty list
    // When the init state is changes, always get an updated favorites list
    if (!favoritesUpdated) {
      asyncGetFavs();
      convertList();
    }

    super.initState();
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
                setState(() {
                  DbService.instance.nukeDatabase();

                  Navigator.pop(ctx);

                  DbService.instance.resetValues();
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    // Put the array in reverse order, so the most recent ones will be at the top
    convertedList = convertedList.reversed.toList();

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
                            // TODO: Handle a local image address rather than a network image
                            imageAddress:
                                convertedList[index].data.images.isEmpty
                                    ? null
                                    : convertedList[index].data.images[0].url,
                            plantId: convertedList[index].data.apiId,
                            onTapAction: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => PlantSpeciesViewer(
                                            plantName:
                                                convertedList[index].data.name,
                                            apiId: 0,
                                            offlineDetails:
                                                convertedList[index],
                                          )));
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
