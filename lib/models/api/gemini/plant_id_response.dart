import 'dart:convert';

class PlantIdResponse {
    List<IdItem> idItems;

    PlantIdResponse({
      required this.idItems,
    });

    factory PlantIdResponse.fromRawJson(String str) => PlantIdResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PlantIdResponse.fromJson(Map<String, dynamic> json) => PlantIdResponse(
        idItems: List<IdItem>.from(json["id_items"].map((x) => IdItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_items": List<dynamic>.from(idItems.map((x) => x.toJson())),
    };
}

class IdItem {
    String? commonName;
    String? scientificName;
    int? idProbabliltyPercentage;
    String? description;

    IdItem({
        this.commonName,
        this.scientificName,
        this.idProbabliltyPercentage,
        this.description,
    });

    factory IdItem.fromRawJson(String str) => IdItem.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory IdItem.fromJson(Map<String, dynamic> json) => IdItem(
        commonName: json["common_name"],
        scientificName: json["scientific_name"],
        idProbabliltyPercentage: json["id_probablilty_percentage"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "common_name": commonName,
        "scientific_name": scientificName,
        "id_probablilty_percentage": idProbabliltyPercentage,
        "description": description,
    };
}