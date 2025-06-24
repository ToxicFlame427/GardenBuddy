import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';

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