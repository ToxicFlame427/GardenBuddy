import 'dart:convert';

class AddPlantRequestModel {
  final String id;
  final String dateSubmitted;
  final String requestedPlants;

  AddPlantRequestModel(
      {required this.id,
      required this.dateSubmitted,
      required this.requestedPlants});

  factory AddPlantRequestModel.fromRawJson(String str) =>
      AddPlantRequestModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddPlantRequestModel.fromJson(Map<String, dynamic> json) =>
      AddPlantRequestModel(
        id: json["id"],
        dateSubmitted: json["dateSubmitted"],
        requestedPlants: json["requestedPlants"]
      );

  Map<String, String> toJson() => {
        "id": id,
        "dateSubmitted": dateSubmitted,
        "requestedPlants": requestedPlants,
      };
}
