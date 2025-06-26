import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garden_buddy/models/api/gemini/ai_constants.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';

// Class for basic input/output operations - local files
class GBIO {
  // This function is used to delete all cached content
  static Future<void> resetApplication() async {
    // Nuke all tables
    await DbService.instance.nukeFavoritesTable();
    await DbService.instance.nukeAiChatsTable();
    await DbService.instance.nukeHaTable();
    await DbService.instance.nukeIdTable();

    // Always delete the database file last
    await DbService.instance.nukeDatabaseFile();

    // Reset all the values
    DbService.instance.resetValues();
  }

  // Easy way to randomize the filename
  static String randomizeFileName(String fileType) {
    String prefix = "GB_${fileType.toUpperCase()}_";
    int random = Random(DateTime.now().millisecondsSinceEpoch).nextInt(2000000);

    return "$prefix$random.$fileType";
  }

  // This function saves an image from url and returns the local filepath and the image ID
  static Future<String?> saveImageFromUrlWithPath(String url) async {
    String? path;

    debugPrint("Attempting to save image...");

    // Need to be really secure with this one boi, bad data can occur!
    try {
      http.Response response = await http.get(Uri.parse(url));

      Directory dir = await getApplicationDocumentsDirectory();

      final file = File("${dir.path}/${randomizeFileName("png")}");
      debugPrint("FILE SAVED TO: $file");
      await file.writeAsBytes(response.bodyBytes);

      // Set the filepath
      path = file.path;
    } on PlatformException catch (error) {
      // Welp, thats not good
      debugPrint("Image save failed: $error");
    }

    // Return path
    return path;
  }

  // TODO: This probably doesn't work, but just some pseudo code to see how it would work
  static Future<String?> saveImageFromFileWithPath(Uint8List fileBytes) async {
    String? path;

    debugPrint("Attempting to save image...");

    // Need to be really secure with this one boi, bad data can occur!
    try {
      Directory dir = await getApplicationDocumentsDirectory();

      final file = File("${dir.path}/${randomizeFileName("png")}");
      debugPrint("FILE SAVED TO: $file");
      await file.writeAsBytes(fileBytes);

      // Set the filepath
      path = file.path;
    } on PlatformException catch (error) {
      // Welp, thats not good
      debugPrint("Image save failed: $error");
    }

    // Return path
    return path;
  }

  // Dammit! Don't use the users' storage so much you fool!
  static void deleteImageWithPath(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        // Check if the file exists
        // If so, delete the file
        file.deleteSync(recursive: true);
        debugPrint("Successfully deleted file: $path");
      } else {
        debugPrint("File not found, could not delete: $path");
      }
    } catch (e) {
      debugPrint("Error deleting file at $path: $e");
    }
  }

  static void saveCurrentDay(DateTime currentDate) async {
    // Setting the date is super simple
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentDate", currentDate.day);

    debugPrint("The current day was set!");
  }

  // These functions are used to verify new day for unsubscribed users
  static Future<bool> isNewDay() async {
    // Get the saved day
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? savedDay = prefs.getInt("currentDate");

    // Save the current date for comparison
    int currentDay = DateTime.now().day;

    if (savedDay != null) {
      // If the date changed, then return true
      if (savedDay > currentDay || savedDay < currentDay) {
        return true;
      } else {
        return false;
      }
    } else {
      debugPrint("There is no date variable!");
      // If there is no date, save it bro!
      saveCurrentDay(DateTime.now());
      return false;
    }
  }

  // Saving the count values will occur after every successful result from the API
  static void saveCountValues() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("idCount", AiConstants.idCount);
    await prefs.setInt("aiCount", AiConstants.aiCount);
    await prefs.setInt("healthCount", AiConstants.healthCount);

    debugPrint("Count values were saved");
  }

  // Checks if the day is new, if so, reset the counts
  static void setCountValues() async {
    saveCurrentDay(DateTime.now());

    if (await isNewDay()) {
      // If a new day has begun, reset the values
      AiConstants.idCount = 1;
      AiConstants.aiCount = 3;
      AiConstants.healthCount = 1;

      // Save the values after being reset
      saveCountValues();
      debugPrint("Count values were reset");
    } else {
      // If a new day has not begun, use previous values stored locally
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      // If the values do not exist locally, set them to their defaults
      AiConstants.idCount = prefs.getInt("idCount") ?? 1;
      AiConstants.aiCount = prefs.getInt("aiCount") ?? 3;
      AiConstants.healthCount = prefs.getInt("healthCount") ?? 1;

      debugPrint("Previous count values were loaded");
    }
  }

  // These functions just read/write values to shared preferences
  static Future<bool> checkIntroComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("introComplete") ?? false;
  }

  static void setIntroComplete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("introComplete", true);
  }

  static Future<bool> checkApiNotice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("apiNoticeComplete") ?? false;
  }

  static void setApiNotice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("apiNoticeComplete", true);
  }

  static Future<void> deleteAllImagesFromTable(String table, Database db, String column) async {
    // Map used to find all local images being saved, they cant hide from this algorithm!
    debugPrint("Fetching all image paths from $table...");
    List<Map<String, dynamic>> allImageEntries = await db.query(
      table,
      columns: [column],
    );

    // Delete each of the local images
    if (allImageEntries.isNotEmpty) {
      for (var entry in allImageEntries) {
        String? imagePath = entry[column] as String?;
        if (imagePath != null && imagePath.isNotEmpty && imagePath != "empty") {
          // Bye bye :)
          GBIO.deleteImageWithPath(imagePath);
          debugPrint("Attempted deletion of cached image: $imagePath");
        }
      }
      debugPrint("Finished attempting to delete all cached images.");
    } else {
      debugPrint("No image paths found in table $table to delete.");
    }
  }
}
