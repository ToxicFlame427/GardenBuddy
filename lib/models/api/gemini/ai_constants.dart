import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:garden_buddy/keys.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiConstants {
  // AI model to be used accross the entire app
  static final GenerativeModel chatModel =
      GenerativeModel(model: "gemini-1.5-flash", apiKey: Keys.geminiApiKey);

  static final GenerativeModel plantIdModel = GenerativeModel(
    model: "gemini-1.5-flash",
    apiKey: Keys.geminiApiKey,
    generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(properties: {
          "id_items": Schema.array(
              nullable: false,
              items: Schema.object(properties: {
                "common_name": Schema.string(
                    description:
                        "Name of the plant, include variety name if possible",
                    nullable: true),
                "scientific_name": Schema.string(
                    description: "Scientific classification", nullable: true),
                "id_probablilty_percentage": Schema.integer(
                    description:
                        "Percentage of match probability from 0 to 100",
                    nullable: false),
                "description": Schema.string(
                    description: "A general description about the plant",
                    nullable: true)
              }))
        })),
  );

  static final GenerativeModel healthAssessModel = GenerativeModel(
    model: "gemini-1.5-flash",
    apiKey: Keys.geminiApiKey,
    generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(properties: {
          "name":
              Schema.string(description: "Name of the plant", nullable: false),
          "scientific_name": Schema.string(
              description: "Scientific classification", nullable: false),
          "health_score_percentage": Schema.integer(
              description: "Percentage of health from bad(0) to good(100)",
              nullable: false),
          "description": Schema.string(
              description:
                  "A general description about the plant's health and image",
              nullable: false),
          "issue_description": Schema.string(
              description: "General description of the plant's issue",
              nullable: false),
          "solution": Schema.string(
              description: "Possible solutions to the plant's issue",
              nullable: false),
          "prevention": Schema.string(
              description:
                  "Prevention methods to prevent the issue for occuring again.",
              nullable: false)
        })),
  );

  // If changes need to be made to persistance, place within the beginninhg of garden ai screen state
  static List<Content> chatHistory = [
    Content("model", [
      TextPart(
          "Okay, I am a plant expert and I will only respond to questions and conversations that are related to gardening, landscaping and/or farming. I will also be very friendly and cheery, during conversations!")
    ])
  ];
  static List<ChatMessage> messages = [];

  // Used to store the current amount unsubscribed users can use for ID and Identifications
  static int idCount = 0;
  static int healthCount = 0;
  static int aiCount = 0;

  /*
    I'm out on the block again, so hopped up that you can't pretend.
    Two time! Stay friends?
    Problem that you can't defend...
    Hands up, feel okay! Whos heart could I break today?
    Two time! Stay friends?
    Problem that you can't defend...
  */
}
