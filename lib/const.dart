// ignore_for_file: constant_identifier_names

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:garden_buddy/models/api/gemini/ai_constants.dart';

// Used universally for ad testing
bool adTesting = true;

// Used for connectivity queries, such as detecting a slow network connection
List<ConnectivityResult> _activeConnections = [];

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

// These functions are used to verify new day for unsubscribed users
bool isNewDay() {
  return true;
}

void setCountValues() {
  if (isNewDay()) {
    // If a new day has begun, reset the values
    AiConstants.idCount = 3;
    AiConstants.aiCount = 3;
    AiConstants.healthCount = 3;
  } else {
    // If a new day has not begun, use previous values stored locally
  }
}
