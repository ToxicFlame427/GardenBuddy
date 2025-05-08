// Used to communicate wiht the local database
import 'package:flutter/foundation.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/db_plant_row.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

    // TODO: Download the image to the system, then get its path and save it to the DB
    String imageDir = "";

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
        .map((e) => DBPlantRow(
            id: e[_favPlantPropId] as int,
            name: e[_favPlantPropName] as String,
            jsonContent: e[_favPlantPropJsonContent] as String,
            localImageDir: e[_favPlantPropLocalImageDir] as String))
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

    // Reset values so no issues arise from the ashes!
    resetValues();
  }

  void deleteFavPlant(String plantName) async {
    final db = await database;
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
