import 'dart:convert';

DiseasesList diseasesListFromJson(String str) => DiseasesList.fromJson(json.decode(str));

String diseasesListToJson(DiseasesList data) => json.encode(data.toJson());

class DiseasesList {
    List<Datum> data;
    int to;
    int perPage;
    int currentPage;
    int from;
    int lastPage;
    int total;

    DiseasesList({
        required this.data,
        required this.to,
        required this.perPage,
        required this.currentPage,
        required this.from,
        required this.lastPage,
        required this.total,
    });

    factory DiseasesList.fromJson(Map<String, dynamic> json) => DiseasesList(
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
    String scientificName;
    List<String>? otherName;
    dynamic family;
    List<Tion> description;
    List<Tion> solution;
    List<String> host;
    List<Image> images;

    Datum({
        required this.id,
        required this.commonName,
        required this.scientificName,
        required this.otherName,
        required this.family,
        required this.description,
        required this.solution,
        required this.host,
        required this.images,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        commonName: json["common_name"],
        scientificName: json["scientific_name"],
        otherName: json["other_name"] == null ? [] : List<String>.from(json["other_name"]!.map((x) => x)),
        family: json["family"],
        description: List<Tion>.from(json["description"].map((x) => Tion.fromJson(x))),
        solution: List<Tion>.from(json["solution"].map((x) => Tion.fromJson(x))),
        host: List<String>.from(json["host"].map((x) => x)),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "common_name": commonName,
        "scientific_name": scientificName,
        "other_name": otherName == null ? [] : List<dynamic>.from(otherName!.map((x) => x)),
        "family": family,
        "description": List<dynamic>.from(description.map((x) => x.toJson())),
        "solution": List<dynamic>.from(solution.map((x) => x.toJson())),
        "host": List<dynamic>.from(host.map((x) => x)),
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
    };
}

class Tion {
    String subtitle;
    String description;

    Tion({
        required this.subtitle,
        required this.description,
    });

    factory Tion.fromJson(Map<String, dynamic> json) => Tion(
        subtitle: json["subtitle"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "subtitle": subtitle,
        "description": description,
    };
}

class Image {
    int license;
    String licenseName;
    String licenseUrl;
    String originalUrl;
    String regularUrl;
    String mediumUrl;
    String smallUrl;
    String thumbnail;

    Image({
        required this.license,
        required this.licenseName,
        required this.licenseUrl,
        required this.originalUrl,
        required this.regularUrl,
        required this.mediumUrl,
        required this.smallUrl,
        required this.thumbnail,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}