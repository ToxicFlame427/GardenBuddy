import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:garden_buddy/models/api/gemini/ai_constants.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Screen size thresholds
const int smallPhoneWidthT = 400;
const int phoneWidthT = 600;
const int tabletWidthT = 900;

// Used universally for ad testing
bool adTesting = false;
bool developerModeEnabled = false;
bool apiNoticeComplete = false;

// Misc
int currentSearchPage = 1;

// Used for connectivity queries, such as detecting a slow network connection
List<ConnectivityResult> _activeConnections = [];

void checkScreenType(context) {
  double screenWidth = MediaQuery.sizeOf(context).width;

  if (screenWidth < smallPhoneWidthT) {
    debugPrint("Small phone screen");
  } else if (screenWidth < phoneWidthT) {
    debugPrint("Regular phone screen");
  } else {
    debugPrint("Tablet screen");
  }

  // Set the length of the plants list to be adaptive to the screen size
  GardenAPIServices.plantsListLength = Responsive.isTablet(context) ? 16 : 10;
}

Future<void> getConnectionTypes() async {
  // Find active connections on app startup to determine app connection compatability
  _activeConnections = await (Connectivity().checkConnectivity());
}

bool checkConnectionIntegrity() {
  if (_activeConnections.contains(ConnectivityResult.mobile) ||
      _activeConnections.contains(ConnectivityResult.wifi)) {
    return true;
  } else {
    return false;
  }
}

// This is used for development mode
void enableDeveloperMode() {
  developerModeEnabled = true;
  PurchasesApi.subStatus = true;
  adTesting = true;
}

void saveCurrentDay(DateTime currentDate) async {
  // Setting the date is super simple
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("currentDate", currentDate.day);

  debugPrint("The current day was set!");
}

/* MARK:
  I want a way to tell the user that they have been trying to change the clock
  This can be done by comparing the hours and day simultaneously to make sure that the hour changed as well
*/
// These functions are used to verify new day for unsubscribed users
Future<bool> isNewDay() async {
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
void saveCountValues() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt("idCount", AiConstants.idCount);
  await prefs.setInt("aiCount", AiConstants.aiCount);
  await prefs.setInt("healthCount", AiConstants.healthCount);

  debugPrint("Count values were saved");
}

// Checks if the day is new, if so, reset the counts
void setCountValues() async {
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
Future<bool> checkIntroComplete() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("introComplete") ?? false;
}

void setIntroComplete() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("introComplete", true);
}

Future<bool> checkApiNotice() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("apiNoticeComplete") ?? false;
}

void setApiNotice() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("apiNoticeComplete", true);
}
