// ignore_for_file: constant_identifier_names

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:garden_buddy/keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Used universally for ad testing
bool adTesting = true;

// AI model to be used accross the entire app
final GenerativeModel aiModel =
    GenerativeModel(model: "gemini-1.5-flash", apiKey: Keys.geminiApiKey);

// If changes need to be made to persistance, place within the beginninhg of garden ai screen state
List<Content> chatHistory = [];
List<ChatMessage> messages = [];

// Used to store the current amount unsubscribed users can use for ID and Identifications
int idCount = 3;
int healthCount = 3;
int aiCount = 3;

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
    idCount = 3;
    aiCount = 3;
    healthCount = 3;
  } else {
    // If a new day has not begun, use previous values stored locally
  }
}
