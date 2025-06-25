import 'package:flutter/foundation.dart';
import 'package:garden_buddy/gbio.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/models/api/gemini/health_assessment_response.dart';
import 'package:garden_buddy/models/api/gemini/plant_id_response.dart';
import 'package:garden_buddy/models/db_models/db_ai_chat.dart';
import 'package:garden_buddy/models/db_models/db_plant_row.dart';
import 'package:garden_buddy/models/services/db_scanner_results.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Used to communicate with the local database
class DbService {
  static Database? _db;

  // Singleton instance, only one in the application
  static final DbService instance = DbService._constructor();

  // Tables
  final String _favoritePlantsTable = "favorite_plants";
  final String _aiChatHistory = "ai_chats";
  final String _idHistory = "id_history";
  final String _haHistory = "ha_history";

  // Column properties
  // UNIVERSAL
  final String _id = "id";
  final String _date = "date";
  final String _results = "results";
  final String _localImageDir = "localImageDir";

  // FAVORITE PLANTS
  final String _favPlantName = "name";
  final String _favPlantJsonContent = "jsonContent";

  // AI CHATS
  final _chatContent = "chatContent";

  // Data storage
  static List<DBPlantRow> favoritePlantsList = [];
  static DBAiChat? aiChatContent;
  static List<DBScannerResults> savedIds = [];
  static List<DBScannerResults> savedHas = [];

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
            $_id INTEGER PRIMARY KEY,
            $_favPlantName TEXT NOT NULL,
            $_favPlantJsonContent TEXT NOT NULL,
            $_localImageDir TEXT NOT NULL
          )
        ''');

        db.execute('''
          CREATE TABLE $_aiChatHistory (
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_chatContent TEXT NOT NULL
          )
        ''');

        // "results" is a string thaat can be converted into a list
        db.execute('''
          CREATE TABLE $_idHistory (
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_date TEXT NOT NULL,
            $_results TEXT NOT NULL,
            $_localImageDir TEXT NOT NULL
          )
        ''');

        db.execute('''
          CREATE TABLE $_haHistory (
            $_id INTEGER PRIMARY KEY AUTOINCREMENT,
            $_date TEXT NOT NULL,
            $_results TEXT NOT NULL,
            $_localImageDir TEXT NOT NULL
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
      imageDir = await GBIO
          .saveImageFromUrlWithPath(plantDetails.data.images[0].smallUrl);

      // Save the image to the system, this is for local reference
      // If the image does not download correctly, then just add the image URL to the local data
      imageDir ??= plantDetails.data.images[0].smallUrl;
    }

    // Get the database instance and insert the parsed data
    final db = await database;
    // The primary key is automatic, there is no need to add it to the schema
    db.insert(_favoritePlantsTable, {
      _favPlantName: plantDetails.data.name,
      _favPlantJsonContent: content,
      _localImageDir: imageDir
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
              id: e[_id] as int,
              name: e[_favPlantName] as String,
              jsonContent: e[_favPlantJsonContent] as String,
              localImageDir: e[_localImageDir] as String),
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
  void deleteFavPlant(String plantName) async {
    final db = await database;

    // This map is used to fin the specific plant to delete
    List<Map<String, dynamic>> plants = await db.query(
      _favoritePlantsTable,
      columns: [_localImageDir],
      where: "$_favPlantName = ?",
      whereArgs: [plantName],
      limit: 1, // Only one plant is needed
    );

    if (plants.isNotEmpty) {
      String? imagePath = plants.first[_localImageDir] as String?;

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
        where: "$_favPlantName = ?", whereArgs: [plantName]);

    favoritePlantsList = await getFavoritePlants();
  }

  // TODO: Complete functions
  void addIdToTable(PlantIdResponse idData) {}

  Future<List<DBScannerResults>?> getIds() async {
    return null;
  }

  void deleteId() async {}

  void addHAToTable(HealthAssessmentResponse haData) {}

  Future<List<DBScannerResults>?> getHAs() async {
    return null;
  }

  void deleteHA() async {}

  void addAiChatToTable(HealthAssessmentResponse haData) {}

  Future<List<DBAiChat>?> getAiChats() async {
    return null;
  }

  void deleteAiChat() async {}

  Future<void> nukeFavoritesTable() async {
    final db = await database;

    await GBIO.deleteAllImagesFromTable(
        _favoritePlantsTable, db, _localImageDir);

    // Delete the table
    await db.execute('DROP TABLE IF EXISTS $_favoritePlantsTable');

    // Recreate the table being empty, with just the one schema
    db.execute('''
      CREATE TABLE $_favoritePlantsTable (
        $_id INTEGER PRIMARY KEY,
        $_favPlantName TEXT NOT NULL,
        $_favPlantJsonContent TEXT NOT NULL,
        $_localImageDir TEXT NOT NULL
      )
    ''');

    // Clear the favorites list
    favoritePlantsList.clear();

    debugPrint("Favorites table nuked and local images cleared.");
  }

  // Deletes the identifictions table and all cached images associated with it
  // TODO: Nuke ID
  Future<void> nukeIdTable() async {
    final db = await database;

    await GBIO.deleteAllImagesFromTable(_idHistory, db, _localImageDir);

    // Delete the table
    await db.execute('DROP TABLE IF EXISTS $_idHistory');

    // Recreate the table being empty, with just the one schema
    db.execute('''
      CREATE TABLE $_idHistory (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_date TEXT NOT NULL,
        $_results TEXT NOT NULL,
        $_localImageDir TEXT NOT NULL
      )
    ''');

    // Clear the favorites list
    savedIds.clear();

    debugPrint("Ids table nuked and local images cleared.");
  }

  // Deletes the health assessments table and all cached images associated with it
  // TODO: Nuke HA
  Future<void> nukeHaTable() async {
    final db = await database;

    await GBIO.deleteAllImagesFromTable(_haHistory, db, _localImageDir);

    // Delete the table
    await db.execute('DROP TABLE IF EXISTS $_haHistory');

    // Recreate the table being empty, with just the one schema
    db.execute('''
      CREATE TABLE $_haHistory (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_date TEXT NOT NULL,
        $_results TEXT NOT NULL,
        $_localImageDir TEXT NOT NULL
      )
    ''');

    // Clear the favorites list
    savedHas.clear();

    debugPrint("HAs table nuked and local images cleared.");
  }

  // Deletes the AI chats table and all cached images associated with it
  // TODO: Nuke chats
  Future<void> nukeAiChatsTable() async {
    final db = await database;

    // Delete the table
    await db.execute('DROP TABLE IF EXISTS $_aiChatHistory');

    // Recreate the table being empty, with just the one schema
    db.execute('''
      CREATE TABLE $_aiChatHistory (
        $_id INTEGER PRIMARY KEY AUTOINCREMENT,
        $_chatContent TEXT NOT NULL
      )
    ''');

    // Clear the favorites list
    aiChatContent = null;

    debugPrint("Ai chats table nuked.");
  }

  // Deletes the base database file storing all tables.
  Future<void> nukeDatabaseFile() async {
    final db = await database;
    String path = db.path;

    await db.close();

    debugPrint("Nuking database file at: $path");

    await deleteDatabase(path);
  }

  void resetValues() {
    _db = null;
    favoritePlantsList = [];
  }
}
