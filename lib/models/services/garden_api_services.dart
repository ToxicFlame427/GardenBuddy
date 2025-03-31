import 'package:garden_buddy/keys.dart';
import 'package:garden_buddy/models/api/garden_api/add_plant_request_model.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_list.dart';
import 'package:http/http.dart' as http;

class GardenAPIServices {
  // For Custom API
  static const String _baseUrlPlants = "https://gardenplantsapi.online/";
  static const String _speciesListEndpoint = "plant-species-list";
  static const String _plantDetailsEndpoint = "single-plant-species";
  static const String _plantRequestEndpoint = "add-plant-request";

  static PlantSpeciesList? plantList;

  static int plantsListPage = 1;
  static int plantsListLength = 15;

  // Fetch the plant species list
  static Future<PlantSpeciesList?> getPlantSpeciesList(
      String? filterQuery, String? searchQuery, int? page) async {
    var client = http.Client();

    // If a page is provided set the page to the given page
    if (page != null) {
      plantsListPage = page;
    } else {
      // If not, set it the default of 1 to 1
      plantsListPage = 1;
    }

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
    var url = Uri.parse(
        "$_baseUrlPlants$_plantDetailsEndpoint/$apiId?key=${Keys.gardenApiKey}");
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

  static Future<bool> sendPlantRequestForm(
      AddPlantRequestModel requestData) async {
    var client = http.Client();

    // Craft the correct URL for the API request
    var url = Uri.parse(
        "$_baseUrlPlants$_plantRequestEndpoint?key=${Keys.gardenApiKey}");

    // Crafting post requests n' shiz
    var response = await client.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestData.toRawJson());

    print("Attempting to send JSON: ${requestData.toRawJson().trim()}");

    // Check the status code based on the response code given
    if (response.statusCode == 200) {
      var responseText = response.body;
      print("Data sent and responded successfully -> $responseText");
      return true;
    } else {
      print(
          "There was a issue sending the data, response code ${response.statusCode}");
      return false;
    }
  }
}
