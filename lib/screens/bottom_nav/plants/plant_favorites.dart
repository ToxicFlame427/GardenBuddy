import 'package:flutter/material.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/widgets/lists/plant_list_card.dart';

class FavoritePlants extends StatefulWidget {
  const FavoritePlants({super.key});

  @override
  State<FavoritePlants> createState() {
    return _FavoritePlantsState();
  }
}

class _FavoritePlantsState extends State<FavoritePlants> {
  @override
  void initState() {
    // If the box does not exist or the list is empty, return an empty list

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: DbService.favoritePlantsList.length,
                itemBuilder: (context, index) {
                  return PlantListCard(
                    plantName: DbService.favoritePlantsList[index].data.name,
                    scientificName:
                        DbService.favoritePlantsList[index].data.scientificName,
                    // TODO: Also, handle these issues as well, where the image is a local path
                    imageAddress:
                        DbService.favoritePlantsList[index].data.images.isEmpty
                            ? null
                            : DbService
                                .favoritePlantsList[index].data.images[0].url,
                    plantId: DbService.favoritePlantsList[index].data.apiId,
                    onTapAction: () {
                      // TODO: Modify this to handle offline data such as the database data
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => PlantSpeciesViewer(
                      //             plantName: GardenAPIServices
                      //                 .plantList!.data[index].name,
                      //             apiId: GardenAPIServices
                      //                 .plantList!.data[index].apiId)));
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
