// Used to communicate wiht the local database
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/db_plant_row.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class DbService {
  static Database? _db;

  // Singleton instance, only one in the application
  static final DbService instance = DbService._constructor();

  // Tables
  final String _favoritePlantsTable = "favorite_plants";

  // Column properties
  final String _favPlantPropId = "id";
  final String _favPlantPropName = "name";
  final String _favPlantPropJsonContent = "jsonContent";
  final String _favPlantPropLocalImageDir = "localImageDir";

  // Data storage - Use globally for comparisons
  static List<DBPlantRow> favoritePlantsList = [];

  DbService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  // Creates and retrieves the database
  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "gb_master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE $_favoritePlantsTable (
            $_favPlantPropId INTEGER PRIMARY KEY,
            $_favPlantPropName TEXT NOT NULL,
            $_favPlantPropJsonContent TEXT NOT NULL,
            $_favPlantPropLocalImageDir TEXT NOT NULL
          )
        ''');
      },
    );

    return database;
  }

  // This function will be responsible for compiling all the data into the database
  void addFavPlant(PlantSpeciesDetails plantDetails) async {
    String content = plantSpeciesDetailsToJson(plantDetails);
    debugPrint(content);

    // Download the image to the system, then get its path and save it to the DB
    String? imageDir = await saveImageWithPath(
        plantDetails.data.images[0].url, plantDetails.data.name);

    // Save the image to the system, this is for local reference
    // If the image does not download correctly, then just add the image URL to the local data
    imageDir ??= plantDetails.data.images[0].url;

    // Get the database instance and insert the parsed data
    final db = await database;
    // The primary key is automatic, there is no need to add it to the schema
    db.insert(_favoritePlantsTable, {
      _favPlantPropName: plantDetails.data.name,
      _favPlantPropJsonContent: content,
      _favPlantPropLocalImageDir: imageDir
    });

    // After adding a favorite plant, update the favorites array
    favoritePlantsList = await getFavoritePlants();
  }

  // This function saves an image from url and returns the local filepath and the image ID
  Future<String?> saveImageWithPath(String url, String fileName) async {
    String? path;

    debugPrint("Attempting to save image...");

    // Need to be really secure with this one boi, bad data can occur!
    try {
      http.Response response = await http.get(Uri.parse(url));

      Directory dir = await getTemporaryDirectory();

      // The random seed is the current sign
      path =
          "${dir.path}/${Random(DateTime.now().millisecondsSinceEpoch).nextInt(1000000)}.png";

      final file = File(path);
      debugPrint("FILE SAVED TO: $file");
      await file.writeAsBytes(response.bodyBytes);
    } on PlatformException catch (error) {
      // Welp, thats not good
      debugPrint("Image save failed: $error");
    }

    debugPrint("Image saving complete, failed or not.");

    // Return path
    return path;
  }

  // This function is sued to delete any local favorite plant images that may be on the system
  // Dammit! Dont use the users' storage so much you fool!
  void deleteLocalImage(String path) async {
    // Well that was easy
    File(path).deleteSync(recursive: true);
  }

  Future<List<DBPlantRow>> getFavoritePlants() async {
    final db = await database;
    final data = await db.query(_favoritePlantsTable);
    List<PlantSpeciesDetails> convertedList = [];

    debugPrint("$data");
    List<DBPlantRow> plants = data
        .map(
          (e) => DBPlantRow(
              id: e[_favPlantPropId] as int,
              name: e[_favPlantPropName] as String,
              jsonContent: e[_favPlantPropJsonContent] as String,
              localImageDir: e[_favPlantPropLocalImageDir] as String),
        )
        .toList();

    // Convert the list of DB rows into usable class elements
    for (int i = 0; i < plants.length; i++) {
      PlantSpeciesDetails converted =
          PlantSpeciesDetails.fromRawJson(plants[i].jsonContent);

      convertedList.add(converted);
    }

    // Return the converted list!
    return plants;
  }

  // MARK: Danger zone!!
  // TODO: Gemini gave me this code, so test it, I did not test it yet, boooooom
  void nukeDatabase() async {
    final db = await database;
    // Send those fuckers into the stratosphere!
    await deleteDatabase(db.path);
  }

  void deleteFavPlant(String plantName) async {
    final db = await database;

    // TODO: Delete the image with the path here!!!!!!
    // First, elete the file at the path
    //deleteLocalImage();

    // "I want this twink obliterated" - Nutter Butter
    await db.delete(_favoritePlantsTable,
        where: "$_favPlantPropName = ?", whereArgs: [plantName]);

    // After deletion, update the favorites array
    favoritePlantsList = await getFavoritePlants();
  }

  void resetValues() {
    _db = null;
    favoritePlantsList = [];
  }
}
