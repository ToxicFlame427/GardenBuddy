import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

// Class for basic input/output operations - local files
class GBIO {
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

      Directory dir = await getTemporaryDirectory();

      final file = File("${dir.path}/${randomizeFileName("png")}");
      debugPrint("FILE SAVED TO: $file");
      await file.writeAsBytes(response.bodyBytes);

      // Set the filepath
      path = file.path;
    } on PlatformException catch (error) {
      // Welp, thats not good
      debugPrint("Image save failed: $error");
    }

    debugPrint("Image saving complete, failed or not.");

    // Return path
    return path;
  }

  // TODO: This probably doesn't work, but just some pseudo code to see how it would work
  static Future<String?> saveImageFromFileWithPath(XFile file) async {
    String? path;

    debugPrint("Attempting to save image...");

    // Need to be really secure with this one boi, bad data can occur!
    try {
      Directory dir = await getTemporaryDirectory();

      final file = File("${dir.path}/${randomizeFileName("png")}");
      debugPrint("FILE SAVED TO: $file");
      await file.writeAsBytes(file.readAsBytesSync());

      // Set the filepath
      path = file.path;
    } on PlatformException catch (error) {
      // Welp, thats not good
      debugPrint("Image save failed: $error");
    }

    debugPrint("Image saving complete, failed or not.");

    // Return path
    return path;
  }

  // Dammit! Dont use the users' storage so much you fool!
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
}
