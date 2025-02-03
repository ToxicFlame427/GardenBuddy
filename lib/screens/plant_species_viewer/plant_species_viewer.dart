import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer_data.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer_loading.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class PlantSpeciesViewer extends StatefulWidget {
  const PlantSpeciesViewer(
      {super.key,
      required this.plantName,
      required this.apiId,
      this.offlineDetails});

  final String plantName;
  final int apiId;
  final PlantSpeciesDetails? offlineDetails;

  @override
  State<PlantSpeciesViewer> createState() {
    return _PlantSpeciesViewerState();
  }
}

// This state handle everything that comes to and from the API and displays it accordingly
class _PlantSpeciesViewerState extends State<PlantSpeciesViewer> {
  final DbService _dbService = DbService.instance;
  bool plantDataIsLoaded = false;
  bool plantIsFavorite = false;
  PlantSpeciesDetails? plantDetails;

  // Immediately request the data from the API based on the API ID of the passed plant
  getPlantDetails() async {
    plantDetails = await GardenAPIServices.getPlantSpeciesDetails(widget.apiId);

    // Check and change according to the plant list
    if (plantDetails != null) {
      setState(() {
        plantDataIsLoaded = true;
      });

      checkFavorite();
    }
  }

  void checkFavorite() {
    if (plantDataIsLoaded) {
      // Check if the plant is already in the favorites list
      for (var i = 0; i < DbService.favoritePlantsList.length; i++) {
        // If the plant is not already a favorite, check the next elements
        if (!plantIsFavorite) {
          setState(() {
            // Check the name of the plant with the name of the plant from the database
            if (plantDetails!.data.name ==
                DbService.favoritePlantsList[i].name) {
              plantIsFavorite = true;
            } else {
              plantIsFavorite = false;
            }
          });
        } else {
          // If a favorite was found, break the loop
          break;
        }
      }
    }
  }

  void addFavoritePlant() {
    _dbService.addFavPlant(plantDetails!);

    setState(() {
      print("Data supposedly added to the database?");
      plantIsFavorite = !plantIsFavorite;
    });
  }

  void removeFavoritePlant() async {
    _dbService.deleteFavPlant(plantDetails!.data.name);

    setState(() {
      print("Data was possibly deleted?");
      plantIsFavorite = !plantIsFavorite;
    });
  }

  @override
  void initState() {
    super.initState();

    // No matter what, automatic handling of null values is already being checked
    if (widget.offlineDetails != null) {
      setState(() {
        plantDetails = widget.offlineDetails;
        plantDataIsLoaded = true;
      });

      checkFavorite();
    }

    // When loaded, immedialty attempt to fetch the species list
    if (!plantDataIsLoaded && plantDetails == null) {
      print("Getting plant details with API ID of ${widget.apiId}...");
      getPlantDetails();
    }
  }

  // For network integrity
  bool networkIntegrity = checkConnectionIntegrity();
  final StreamController<SwipeRefreshState> _refreshController =
      StreamController<SwipeRefreshState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.plantName,
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Khand",
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (plantIsFavorite) {
                removeFavoritePlant();
              } else {
                addFavoritePlant();
              }
            },
            icon:
                Icon(plantIsFavorite ? Icons.favorite : Icons.favorite_border),
            color: plantIsFavorite ? Colors.red : Colors.white,
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: false,
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
      body: Visibility(
          visible: plantDataIsLoaded,
          replacement: PlantSpeciesViewerLoading(),
          child: PlantSpeciesViewerData(plantData: plantDetails)),
    );
  }
}
