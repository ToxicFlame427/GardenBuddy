import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/perenual/diseases_list.dart';
import 'package:garden_buddy/models/api/perenual/plant_species_list.dart';
import 'package:http/http.dart' as http;

class PerenualAPIServices {
  // Fetch the plant species list from the Perenual API
  static Future<PlantSpeciesList?> getPlantSpeciesList() async {
    var client = http.Client();

    // Craft the correct URL for the API request
    var url = Uri.parse(
        "$BASE_URL_PERENUAL$SPECIES_LIST_ENDPOINT_PERENUAL?key=$PERENUAL_API_KEY");
    var response = await client.get(url);

    // Check the status code based on the response code given
    if (response.statusCode == 200) {
      var json = response.body;
      print("Data retrieved successfully");
      return plantSpeciesListFromJson(json);
    } else {
      print(
          "There was a issue retrieving the data, response code ${response.statusCode}");
      return null;
    }
  }

  // Fetch the diseases list from the Perenual API
  static Future<DiseasesList?> getDiseaseList() async {
    var client = http.Client();

    // Craft the correct URL for the API request
    var url = Uri.parse(
        "$BASE_URL_PERENUAL$DISEASE_LIST_ENDPOINT_PERENUAL?key=$PERENUAL_API_KEY");
    var response = await client.get(url);

    // Check the status code based on the response code given
    if (response.statusCode == 200) {
      var json = response.body;
      print("Data retrieved successfully");
      return diseasesListFromJson(json);
    } else {
      print(
        "There was a issue retrieving the data, response code ${response.statusCode}");
      return null;
    }
  }
}
