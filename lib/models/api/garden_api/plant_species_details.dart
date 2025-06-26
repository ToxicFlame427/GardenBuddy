import 'dart:convert';

class PlantSpeciesDetails {
  Data data;
  String status;
  String message;

  PlantSpeciesDetails({
    required this.data,
    required this.status,
    required this.message,
  });

  factory PlantSpeciesDetails.fromRawJson(String str) =>
      PlantSpeciesDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlantSpeciesDetails.fromJson(Map<String, dynamic> json) =>
      PlantSpeciesDetails(
        data: Data.fromJson(json["data"]),
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "message": message,
      };
}

class Data {
  int apiId;
  AverageHeight averageHeight;
  AverageHeight averageSpread;
  String name;
  String description;
  List<String> floweringMonths;
  String floweringSeason;
  bool fruitIsEdible;
  String growingCycle;
  int growthRate;
  HardinessZones hardinessZones;
  List<String> harvestMonths;
  String harvestSeason;
  String harvestingGuide;
  bool hasFlowers;
  bool hasSeeds;
  bool hasCorms;
  List<Image> images;
  bool containerFriendly;
  bool frostTolerant;
  bool heatTolerant;
  bool indoorFriendly;
  bool medicinal;
  bool poisonousToHumans;
  bool poisonousToPets;
  bool saltTolerant;
  String speciesOrVariety;
  bool leavesAreEdible;
  int maintenanceLevel;
  Time maturityTime;
  List<String> otherNames;
  AverageHeight plantSpacing;
  List<String> plantingMonths;
  String plantingSeason;
  List<String> preferredSoil;
  List<String> preferredSunlight;
  String pruningGuide;
  String scientificName;
  Time seedGerminationTime;
  bool seedsAreEdible;
  String soilPh;
  String sowingGuide;
  String wateringGuide;
  String patentStatus;

  /*
    Nothing kills you faster than your own mind.
    Be calm.
    Don't stress over things that are out of your control.
  */

  Data(
      {required this.apiId,
      required this.averageHeight,
      required this.averageSpread,
      required this.name,
      required this.description,
      required this.floweringMonths,
      required this.floweringSeason,
      required this.fruitIsEdible,
      required this.growingCycle,
      required this.growthRate,
      required this.hardinessZones,
      required this.harvestMonths,
      required this.harvestSeason,
      required this.harvestingGuide,
      required this.hasFlowers,
      required this.hasSeeds,
      required this.hasCorms,
      required this.images,
      required this.containerFriendly,
      required this.frostTolerant,
      required this.heatTolerant,
      required this.indoorFriendly,
      required this.medicinal,
      required this.poisonousToHumans,
      required this.poisonousToPets,
      required this.saltTolerant,
      required this.speciesOrVariety,
      required this.leavesAreEdible,
      required this.maintenanceLevel,
      required this.maturityTime,
      required this.otherNames,
      required this.plantSpacing,
      required this.plantingMonths,
      required this.plantingSeason,
      required this.preferredSoil,
      required this.preferredSunlight,
      required this.pruningGuide,
      required this.scientificName,
      required this.seedGerminationTime,
      required this.seedsAreEdible,
      required this.soilPh,
      required this.sowingGuide,
      required this.wateringGuide,
      required this.patentStatus});

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      apiId: json["apiId"],
      averageHeight: AverageHeight.fromJson(json["averageHeight"]),
      averageSpread: AverageHeight.fromJson(json["averageSpread"]),
      name: json["name"],
      description: json["description"],
      floweringMonths: List<String>.from(json["floweringMonths"].map((x) => x)),
      floweringSeason: json["floweringSeason"],
      fruitIsEdible: json["fruitIsEdible"],
      growingCycle: json["growingCycle"],
      growthRate: json["growthRate"],
      hardinessZones: HardinessZones.fromJson(json["hardinessZones"]),
      harvestMonths: List<String>.from(json["harvestMonths"].map((x) => x)),
      harvestSeason: json["harvestSeason"],
      harvestingGuide: json["harvestingGuide"],
      hasFlowers: json["hasFlowers"],
      hasSeeds: json["hasSeeds"],
      hasCorms: json["hasCorms"],
      images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      containerFriendly: json["containerFriendly"],
      frostTolerant: json["frostTolerant"],
      heatTolerant: json["heatTolerant"],
      indoorFriendly: json["indoorFriendly"],
      medicinal: json["medicinal"],
      poisonousToHumans: json["poisonousToHumans"],
      poisonousToPets: json["poisonousToPets"],
      saltTolerant: json["saltTolerant"],
      speciesOrVariety: json["speciesOrVariety"],
      leavesAreEdible: json["leavesAreEdible"],
      maintenanceLevel: json["maintenanceLevel"],
      maturityTime: Time.fromJson(json["maturityTime"]),
      otherNames: List<String>.from(json["otherNames"].map((x) => x)),
      plantSpacing: AverageHeight.fromJson(json["plantSpacing"]),
      plantingMonths: List<String>.from(json["plantingMonths"].map((x) => x)),
      plantingSeason: json["plantingSeason"],
      preferredSoil: List<String>.from(json["preferredSoil"].map((x) => x)),
      preferredSunlight:
          List<String>.from(json["preferredSunlight"].map((x) => x)),
      pruningGuide: json["pruningGuide"],
      scientificName: json["scientificName"],
      seedGerminationTime: Time.fromJson(json["seedGerminationTime"]),
      seedsAreEdible: json["seedsAreEdible"],
      soilPh: json["soilPh"],
      sowingGuide: json["sowingGuide"],
      wateringGuide: json["wateringGuide"],
      patentStatus: json["patentStatus"]);

  Map<String, dynamic> toJson() => {
        "apiId": apiId,
        "averageHeight": averageHeight.toJson(),
        "averageSpread": averageSpread.toJson(),
        "name": name,
        "description": description,
        "floweringMonths": List<dynamic>.from(floweringMonths.map((x) => x)),
        "floweringSeason": floweringSeason,
        "fruitIsEdible": fruitIsEdible,
        "growingCycle": growingCycle,
        "growthRate": growthRate,
        "hardinessZones": hardinessZones.toJson(),
        "harvestMonths": List<dynamic>.from(harvestMonths.map((x) => x)),
        "harvestSeason": harvestSeason,
        "harvestingGuide": harvestingGuide,
        "hasFlowers": hasFlowers,
        "hasSeeds": hasSeeds,
        "hasCorms": hasCorms,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "containerFriendly": containerFriendly,
        "frostTolerant": frostTolerant,
        "heatTolerant": heatTolerant,
        "indoorFriendly": indoorFriendly,
        "medicinal": medicinal,
        "poisonousToHumans": poisonousToHumans,
        "poisonousToPets": poisonousToPets,
        "saltTolerant": saltTolerant,
        "speciesOrVariety": speciesOrVariety,
        "leavesAreEdible": leavesAreEdible,
        "maintenanceLevel": maintenanceLevel,
        "maturityTime": maturityTime.toJson(),
        "otherNames": List<dynamic>.from(otherNames.map((x) => x)),
        "plantSpacing": plantSpacing.toJson(),
        "plantingMonths": List<dynamic>.from(plantingMonths.map((x) => x)),
        "plantingSeason": plantingSeason,
        "preferredSoil": List<dynamic>.from(preferredSoil.map((x) => x)),
        "preferredSunlight":
            List<dynamic>.from(preferredSunlight.map((x) => x)),
        "pruningGuide": pruningGuide,
        "scientificName": scientificName,
        "seedGerminationTime": seedGerminationTime.toJson(),
        "seedsAreEdible": seedsAreEdible,
        "soilPh": soilPh,
        "sowingGuide": sowingGuide,
        "wateringGuide": wateringGuide,
        "patentStatus": patentStatus
      };
}

class AverageHeight {
  String unit;
  String value;

  AverageHeight({
    required this.unit,
    required this.value,
  });

  factory AverageHeight.fromRawJson(String str) =>
      AverageHeight.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AverageHeight.fromJson(Map<String, dynamic> json) => AverageHeight(
        unit: json["unit"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "value": value,
      };
}

class HardinessZones {
  int maxHardiness;
  int minHardiness;

  HardinessZones({
    required this.maxHardiness,
    required this.minHardiness,
  });

  factory HardinessZones.fromRawJson(String str) =>
      HardinessZones.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HardinessZones.fromJson(Map<String, dynamic> json) => HardinessZones(
        maxHardiness: json["maxHardiness"],
        minHardiness: json["minHardiness"],
      );

  Map<String, dynamic> toJson() => {
        "maxHardiness": maxHardiness,
        "minHardiness": minHardiness,
      };
}

class Image {
  String credit;
  String imageLicense;
  String originalUrl;
  String smallUrl;
  String url;
  String? licenseCode;

  Image(
      {required this.credit,
      required this.imageLicense,
      required this.originalUrl,
      required this.url,
      required this.smallUrl,
      this.licenseCode});

  factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Image.fromJson(Map<String, dynamic> json) => Image(
      credit: json["credit"],
      imageLicense: json["imageLicense"],
      originalUrl: json["originalUrl"],
      url: json["url"],
      smallUrl: json["smallUrl"],
      licenseCode: json["licenseCode"]);

  Map<String, dynamic> toJson() => {
        "credit": credit,
        "imageLicense": imageLicense,
        "originalUrl": originalUrl,
        "url": url,
        "smallUrl": smallUrl,
        "licenseUrl": licenseCode
      };
}

class Time {
  String time;
  String unit;

  Time({
    required this.time,
    required this.unit,
  });

  factory Time.fromRawJson(String str) => Time.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        time: json["time"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "unit": unit,
      };
}
