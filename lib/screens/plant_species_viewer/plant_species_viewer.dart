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
      {super.key, required this.plantName, required this.apiId});

  final String plantName;
  final int apiId;

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
    }
  }

  void addFavoritePlant() {
    _dbService.addFavPlant(plantDetails!);

    setState(() {
      print("Data supposedly added to the database?");
      plantIsFavorite = !plantIsFavorite;
    });
  }

  void removeFavoritePlant() {
    
  }

  @override
  void initState() {
    super.initState();

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
              addFavoritePlant();
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
