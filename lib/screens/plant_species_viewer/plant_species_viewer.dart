import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/screens/plant_species_viewer/plant_species_viewer_data.dart';
import 'package:garden_buddy/widgets/loading/plant_viewer_loading.dart';

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
  bool _favoritesChanged = false;

  // Immediately request the data from the API based on the API ID of the passed plant
  getPlantDetails() async {
    plantDetails = await GardenAPIServices.getPlantSpeciesDetails(widget.apiId);

    // Check and change according to the plant list
    if (plantDetails != null) {
      setState(() {
        plantDataIsLoaded = true;
        _favoritesChanged = true;
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
      plantIsFavorite = !plantIsFavorite;
      _favoritesChanged = true;
    });
  }

  void removeFavoritePlant() async {
    _dbService.deleteFavPlant(plantDetails!.data.name);

    setState(() {
      plantIsFavorite = !plantIsFavorite;
      _favoritesChanged = true;
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
      getPlantDetails();
    }
  }

  // For network integrity
  bool networkIntegrity = checkConnectionIntegrity();
  //final StreamController<SwipeRefreshState> _refreshController =StreamController<SwipeRefreshState>();

  @override
  Widget build(BuildContext context) {
    // Pop scope is used to detect changes to the favorites list in the previous page
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => {
        if (!didPop)
          {
            if (mounted) {Navigator.pop(context, _favoritesChanged)}
          }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (mounted) {
                Navigator.pop(context, _favoritesChanged);
              }
            },
          ),
          title: Text(
            widget.plantName,
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Khand",
                fontWeight: FontWeight.bold),
          ),
          actions: [
            // if (plantDataIsLoaded && widget.offlineDetails == null)
            //   IconButton(
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            //         return PlantEditRequestScreen(plantDetails: plantDetails!);
            //       }));
            //     },
            //     icon: Icon(Icons.edit_document),
            //     color: Colors.white,
            //   ),
            // Only show the favorite button if the plant data is loaded
            if (plantDataIsLoaded)
              IconButton(
                onPressed: () {
                  if (plantIsFavorite) {
                    removeFavoritePlant();
                  } else {
                    addFavoritePlant();
                  }
                },
                icon: Icon(
                    plantIsFavorite ? Icons.favorite : Icons.favorite_border),
                color: plantIsFavorite ? Colors.red : Colors.white,
              )
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: false,
          iconTheme: const IconThemeData().copyWith(color: Colors.white),
        ),
        body: Visibility(
            visible: plantDataIsLoaded,
            replacement: PlantViewerLoading(),
            child: PlantSpeciesViewerData(plantData: plantDetails)),
      ),
    );
  }
}
