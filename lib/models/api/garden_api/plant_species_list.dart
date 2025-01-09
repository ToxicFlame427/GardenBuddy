import 'dart:convert';

PlantSpeciesList plantSpeciesListFromJson(String str) => PlantSpeciesList.fromJson(json.decode(str));

String plantSpeciesListToJson(PlantSpeciesList data) => json.encode(data.toJson());

class PlantSpeciesList {
    List<Datum> data;
    int itemCount;
    int page;
    String status;
    String message;

    PlantSpeciesList({
        required this.data,
        required this.itemCount,
        required this.page,
        required this.status,
        required this.message,
    });

    factory PlantSpeciesList.fromJson(Map<String, dynamic> json) => PlantSpeciesList(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        itemCount: json["itemCount"],
        page: json["page"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "itemCount": itemCount,
        "page": page,
        "status": status,
        "message": message,
    };
}

class Datum {
    int apiId;
    String name;
    String growingCycle;
    List<Image> images;
    String speciesOrVariety;
    List<String> otherNames;
    String scientificName;

    Datum({
        required this.apiId,
        required this.name,
        required this.growingCycle,
        required this.images,
        required this.speciesOrVariety,
        required this.otherNames,
        required this.scientificName,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        apiId: json["apiId"],
        name: json["name"],
        growingCycle: json["growingCycle"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        speciesOrVariety: json["speciesOrVariety"],
        otherNames: List<String>.from(json["otherNames"].map((x) => x)),
        scientificName: json["scientificName"],
    );

    Map<String, dynamic> toJson() => {
        "apiId": apiId,
        "name": name,
        "growingCycle": growingCycle,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "isSpeciesOrVariety": speciesOrVariety,
        "otherNames": List<dynamic>.from(otherNames.map((x) => x)),
        "scientificName": scientificName,
    };
}

class Image {
    String credit;
    String imageLicense;
    String originalUrl;
    String url;

    Image({
        required this.credit,
        required this.imageLicense,
        required this.originalUrl,
        required this.url,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        credit: json["credit"],
        imageLicense: json["imageLicense"],
        originalUrl: json["originalUrl"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "credit": credit,
        "imageLicense": imageLicense,
        "originalUrl": originalUrl,
        "url": url,
    };
}