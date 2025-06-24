import 'package:flutter/foundation.dart';
import 'package:garden_buddy/gbio.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/db_plant_row.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Used to communicate with the local database
class DbService {
  static Database? _db;

  // Singleton instance, only one in the application
  static final DbService instance = DbService._constructor();

  // Tables
  final String _favoritePlantsTable = "favorite_plants";
  final String _aiChatHistory = "ai_chat_history";
  final String _idHistory = "id_history";
  final String _haHistory = "ha_history";

  // Column properties
  // FAVORITE PLANTS
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

    String? imageDir = "empty";

    // Download the image to the system, then get its path and save it to the DB
    if (plantDetails.data.images.isNotEmpty) {
      imageDir =
          await GBIO.saveImageFromUrlWithPath(plantDetails.data.images[0].smallUrl);

      // Save the image to the system, this is for local reference
      // If the image does not download correctly, then just add the image URL to the local data
      imageDir ??= plantDetails.data.images[0].smallUrl;
    }

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
  Future<void> nukeDatabase() async {
    final db = await database;

    // Map used to find all local image being saved, they cant hide from this algorithm!
    debugPrint("Fetching all image paths before nuking database...");
    List<Map<String, dynamic>> allImageEntries = await db.query(
      _favoritePlantsTable,
      columns: [_favPlantPropLocalImageDir],
    );

    // Delete each of the local images
    if (allImageEntries.isNotEmpty) {
      for (var entry in allImageEntries) {
        String? imagePath = entry[_favPlantPropLocalImageDir] as String?;
        if (imagePath != null && imagePath.isNotEmpty && imagePath != "empty") {
          // Bye bye :)
          GBIO.deleteImageWithPath(imagePath);
          debugPrint("Attempted deletion of cached image: $imagePath");
        }
      }
      debugPrint("Finished attempting to delete all cached images.");
    } else {
      debugPrint("No image paths found in the database to delete.");
    }

    String path = db.path;

    await db.close();

    // "Send those fuckers into the stratosphere!"
    debugPrint("Nuking database file at: $path");
    await deleteDatabase(path);

    resetValues();

    debugPrint("Database nuked and local images cleared.");
  }

  void deleteFavPlant(String plantName) async {
    final db = await database;

    // This map is used to fin the specific plant to delete
    List<Map<String, dynamic>> plants = await db.query(
      _favoritePlantsTable,
      columns: [_favPlantPropLocalImageDir],
      where: "$_favPlantPropName = ?",
      whereArgs: [plantName],
      limit: 1, // Only one plant is needed
    );

    if (plants.isNotEmpty) {
      String? imagePath = plants.first[_favPlantPropLocalImageDir] as String?;

      if (imagePath != null && imagePath.isNotEmpty && imagePath != "empty") {
        GBIO.deleteImageWithPath(imagePath);
        debugPrint("Deleted local image at: $imagePath");
      } else {
        debugPrint(
            "No valid local image path found for $plantName or path was 'empty'.");
      }
    } else {
      debugPrint("Plant with name $plantName not found for image deletion.");
    }

    await db.delete(_favoritePlantsTable,
        where: "$_favPlantPropName = ?", whereArgs: [plantName]);

    favoritePlantsList = await getFavoritePlants();
  }

  void resetValues() {
    _db = null;
    favoritePlantsList = [];
  }
}
