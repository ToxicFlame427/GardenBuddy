import 'package:garden_buddy/keys.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_list.dart';
import 'package:http/http.dart' as http;

class GardenAPIServices {
  // For Custom API
  static const String _baseUrlPlants = "https://gardenplantsapi.online/";
  static const String _speciesListEndpoint = "plant-species-list";
  static const String _plantDetailsEndpoint = "single-plant-species";

  static PlantSpeciesList? plantList;

  static int plantsListPage = 1;
  static int plantsListLength = 15;

  // Fetch the plant species list
  static Future<PlantSpeciesList?> getPlantSpeciesList(
      String? filterQuery, String? searchQuery) async {
    var client = http.Client();

    print("Searching for $searchQuery");

    // Craft the correct URL for the API request
    var url = Uri.parse(
        "$_baseUrlPlants$_speciesListEndpoint?limit=$plantsListLength&page=$plantsListPage&fq=$filterQuery&sq=$searchQuery&key=${Keys.gardenApiKey}");
    var response = await client.get(url);

    // Check the status code based on the response code given
    if (response.statusCode == 200) {
      var json = response.body;
      print("Data retrieved successfully ${json}");
      return plantSpeciesListFromJson(json);
    } else {
      print(
          "There was a issue retrieving the data, response code ${response.statusCode}");
      return null;
    }
  }

  // Fetch the plant species details by API ID
  static Future<PlantSpeciesDetails?> getPlantSpeciesDetails(int apiId) async {
    var client = http.Client();

    // Craft the correct URL for the API request
    var url = Uri.parse("$_baseUrlPlants$_plantDetailsEndpoint/$apiId?key=${Keys.gardenApiKey}");
    var response = await client.get(url);

    // Check the status code based on the response code given
    if (response.statusCode == 200) {
      var json = response.body;
      print("Data retrieved successfully ${json}");
      return PlantSpeciesDetails.fromRawJson(json);
    } else {
      print(
          "There was a issue retrieving the data, response code ${response.statusCode}");
      return null;
    }
  }

  // Fetch the diseases list from the Perenual API
  // static Future<DiseasesList?> getDiseaseList() async {
  //   var client = http.Client();

  //   // Craft the correct URL for the API request
  //   var url = Uri.parse(
  //       "$BASE_URL_PERENUAL$DISEASE_LIST_ENDPOINT_PERENUAL?key=$PERENUAL_API_KEY&page=$diseasesListPage");
  //   var response = await client.get(url);

  //   // Check the status code based on the response code given
  //   if (response.statusCode == 200) {
  //     var json = response.body;
  //     print("Data retrieved successfully");
  //     return diseasesListFromJson(json);
  //   } else {
  //     print(
  //         "There was a issue retrieving the data, response code ${response.statusCode}");
  //     return null;
  //   }
  // }
}
