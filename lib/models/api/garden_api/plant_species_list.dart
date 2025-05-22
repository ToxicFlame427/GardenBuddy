import 'dart:convert';

import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';

PlantSpeciesList plantSpeciesListFromJson(String str) => PlantSpeciesList.fromJson(json.decode(str));

String plantSpeciesListToJson(PlantSpeciesList data) => json.encode(data.toJson());

class PlantSpeciesList {
    List<Datum> data;
    int itemCount;
    int page;
    int pages;
    String status;
    String message;

    PlantSpeciesList({
        required this.data,
        required this.itemCount,
        required this.page,
        required this.pages,
        required this.status,
        required this.message,
    });

    factory PlantSpeciesList.fromJson(Map<String, dynamic> json) => PlantSpeciesList(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        itemCount: json["itemCount"],
        page: json["page"],
        pages: json["pages"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "itemCount": itemCount,
        "page": page,
        "pages": pages,
        "status": status,
        "message": message,
    };
}

class Datum {
    int apiId;
    String name;
    List<Image> images;
    String scientificName;

    Datum({
        required this.apiId,
        required this.name,
        required this.images,
        required this.scientificName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        apiId: json["apiId"],
        name: json["name"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        scientificName: json["scientificName"],
    );

    Map<String, dynamic> toJson() => {
        "apiId": apiId,
        "name": name,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "scientificName": scientificName,
    };
}