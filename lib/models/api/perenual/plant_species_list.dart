import 'dart:convert';

PlantSpeciesList plantSpeciesListFromJson(String str) =>
    PlantSpeciesList.fromJson(json.decode(str));

String plantSpeciesListToJson(PlantSpeciesList data) =>
    json.encode(data.toJson());

class PlantSpeciesList {
  List<Datum> data;
  int to;
  int perPage;
  int currentPage;
  int from;
  int lastPage;
  int total;

  PlantSpeciesList({
    required this.data,
    required this.to,
    required this.perPage,
    required this.currentPage,
    required this.from,
    required this.lastPage,
    required this.total,
  });

  factory PlantSpeciesList.fromJson(Map<String, dynamic> json) =>
      PlantSpeciesList(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        to: json["to"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "to": to,
        "per_page": perPage,
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "total": total,
      };
}

class Datum {
  int id;
  String commonName;
  List<String> scientificName;
  List<String> otherName;
  String cycle;
  String watering;
  List<String> sunlight;
  DefaultImage? defaultImage;

  Datum({
    required this.id,
    required this.commonName,
    required this.scientificName,
    required this.otherName,
    required this.cycle,
    required this.watering,
    required this.sunlight,
    required this.defaultImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        commonName: json["common_name"],
        scientificName:
            List<String>.from(json["scientific_name"].map((x) => x)),
        otherName: List<String>.from(json["other_name"].map((x) => x)),
        cycle: json["cycle"],
        watering: json["watering"],
        sunlight: List<String>.from(
            json["sunlight"].map((x) => x)),
        defaultImage: json["default_image"] == null
            ? null
            : DefaultImage.fromJson(json["default_image"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "common_name": commonName,
        "scientific_name": List<dynamic>.from(scientificName.map((x) => x)),
        "other_name": List<dynamic>.from(otherName.map((x) => x)),
        "cycle": cycle,
        "watering": watering,
        "sunlight":
            List<dynamic>.from(sunlight.map((x) => x)),
        "default_image": defaultImage?.toJson(),
      };
}

class DefaultImage {
  int license;
  String licenseName;
  String licenseUrl;
  String originalUrl;
  String regularUrl;
  String mediumUrl;
  String smallUrl;
  String thumbnail;

  DefaultImage({
    required this.license,
    required this.licenseName,
    required this.licenseUrl,
    required this.originalUrl,
    required this.regularUrl,
    required this.mediumUrl,
    required this.smallUrl,
    required this.thumbnail,
  });

  factory DefaultImage.fromJson(Map<String, dynamic> json) => DefaultImage(
        license: json["license"],
        licenseName: json["license_name"],
        licenseUrl: json["license_url"],
        originalUrl: json["original_url"],
        regularUrl: json["regular_url"],
        mediumUrl: json["medium_url"],
        smallUrl: json["small_url"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "license": license,
        "license_name": licenseName,
        "license_url": licenseUrl,
        "original_url": originalUrl,
        "regular_url": regularUrl,
        "medium_url": mediumUrl,
        "small_url": smallUrl,
        "thumbnail": thumbnail,
      };
}
