import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/gemini/health_assessment_response.dart';
import 'package:garden_buddy/models/api/gemini/plant_id_response.dart';
import 'package:garden_buddy/widgets/lists/plant_id_card.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class ScannerResultScreen extends StatefulWidget {
  const ScannerResultScreen(
      {super.key, required this.picture, required this.scannerType});

  final String scannerType;
  final XFile picture;

  @override
  State<ScannerResultScreen> createState() {
    return _ScannerResultState();
  }
}

class _ScannerResultState extends State<ScannerResultScreen> {
  bool recievedResult = false;
  String? response;

  PlantIdResponse? idResponse;
  HealthAssessmentResponse? healthResponse;

  // Used to send the prompt to the Gemini model
  Future<void> sendPrompt() async {
    TextPart prompt;
    Uint8List imagebytes = await widget.picture.readAsBytes();

    // Determine the correct prompt to send based on what scanner is being used
    if (widget.scannerType == "Plant Identification") {
      prompt = TextPart(
          """What plant is this? Can you fill out this JSON object? You can have more than one possibility. Respond only with this json object: {"id_items": [{"common_name": "","scientific_name": "","id_probablilty_percentage": 0,"description": ""}]}""");
    } else {
      prompt = TextPart(
          """How healthy is this plant? Can you fill out this JSON object? If unknown, please put "Unknown" in the issue_description Respond only with this json object: {"name": "","scientific_name": "","health_score_percentage": 0,"issue_description": "","solution": "","prevention": ""}""");
    }

    var getter = await aiModel.generateContent([
      Content.multi(
          // Assuming that the image has a defines MIME type
          [prompt, DataPart("image/jpeg", imagebytes)])
    ]);

    // Set the state on response
    setState(() {
      response = getter.text;

      // Format the string to exclude the json code profiling "json```<code>```"
      String formatString = response!
          .substring(response!.indexOf("{"), response!.lastIndexOf("}") + 1);

      // Set the respective scanner to the correcponding object recieved
      if (widget.scannerType == "Plant Identification") {
        idResponse = PlantIdResponse.fromRawJson(formatString);
      } else {
        healthResponse = HealthAssessmentResponse.fromRawJson(formatString);
      }

      recievedResult = true;
    });
  }

  @override
  void initState() {
    // Run the correct prompt based on what scanner type is passed in
    if (!recievedResult) {
      sendPrompt();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.scannerType} Results",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "Khand",
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            child: Image.file(
              File(widget.picture.path),
              height: 175,
              width: double.maxFinite,
              fit: BoxFit.cover,
            ),
          ),
          // Display the data based on if the result was recieved or not
          if (recievedResult)
            // Depending on the scanner type, show data
            if (widget.scannerType == "Plant Identification")
              _PlantIdResultsWidget(data: idResponse!)
            else
              _HealthAssessResultsWidget(data: healthResponse!)
          else
            _ResultLoading()
        ],
      ),
    );
    // For displaying the image: Image.file(File(widget.picture.path));
  }
}

class _PlantIdResultsWidget extends StatelessWidget {
  const _PlantIdResultsWidget({required this.data});

  final PlantIdResponse data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Identification AI Generated (Gemini)",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: data.idItems.length,
              itemBuilder: (context, index) {
                return PlantIdCard(data: data.idItems[index]);
              }),
        ],
      ),
    );
  }
}

class _HealthAssessResultsWidget extends StatelessWidget {
  const _HealthAssessResultsWidget({required this.data});

  final HealthAssessmentResponse data;

  @override
  Widget build(BuildContext context) {
    return Text("Health assessment results");
  }
}

class _ResultLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Loading");
  }
}
