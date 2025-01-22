import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/gemini/ai_constants.dart';
import 'package:garden_buddy/models/api/gemini/health_assessment_response.dart';
import 'package:garden_buddy/models/api/gemini/plant_id_response.dart';
import 'package:garden_buddy/theming/colors.dart';
import 'package:garden_buddy/widgets/formatting/horizontal_rule.dart';
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
  dynamic getter;

  PlantIdResponse? idResponse;
  HealthAssessmentResponse? healthResponse;

  // Used to send the prompt to the Gemini model
  Future<void> sendPrompt() async {
    TextPart prompt;
    Uint8List imagebytes = await widget.picture.readAsBytes();

    // Determine the correct prompt to send based on what scanner is being used
    if (widget.scannerType == "Plant Identification") {
      prompt = TextPart(
          """What plant is this? List possible plants, more than one if possible. If unknown or there aren't any plants, leave array empty. Please guess the exact plant to the best of your ability and if possble, include "Name 'Variety'" name.""");
    } else {
      prompt = TextPart(
          """How healthy is this plant? What is wrong with it? If it looks very healthy, put "None" in issue_description and leave solution and prevention blank. If unknown, please put "Unknown" in the issue_description and if the image doesnt have a plant, put "No Plant". Please be very descriptive just based off the image. If the plant cant be identified, leave name and scientific_name empty""");
    }

    if (widget.scannerType == "Plant Identification") {
      getter = await AiConstants.plantIdModel.generateContent([
        Content.multi(
            // Assuming that the image has a defines MIME type
            [prompt, DataPart("image/jpeg", imagebytes)])
      ]);
    } else {
      getter = await AiConstants.healthAssessModel.generateContent([
        Content.multi(
            // Assuming that the image has a defines MIME type
            [prompt, DataPart("image/jpeg", imagebytes)])
      ]);
    }

    // Set the state on response
    setState(() {
      response = getter.text;

      // Format the string to exclude the json code profiling "json```<code>```"
      String formatString = response!
          .substring(response!.indexOf("{"), response!.lastIndexOf("}") + 1);

      print(formatString);

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
          // MARK: This hierarchy of conditionals is weird
          // Display the data based on if the result was recieved or not
          if (recievedResult)
            // Depending on the scanner type, show data
            if (widget.scannerType == "Plant Identification")
              // Check if data is present
              if (idResponse!.idItems.isNotEmpty)
                _PlantIdResultsWidget(data: idResponse!)
              else
                _NoDataWidget()
            else
            // Check if data can be displayed correctly
            if (healthResponse!.issueDescription != "No Plant")
              _HealthAssessResultsWidget(data: healthResponse!)
            else
              _NoDataWidget()
          else
            _ResultLoading()
        ],
      ),
    );
  }
}

class _NoDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No Data",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            "This can be due to",
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          Text("- A blurry image"),
          Text("- An image that does not contain a plant"),
          Text("- Bad response"),
          Text("- No network connection"),
          SizedBox(
            height: 35,
          ),
          Text(
              "Please check all of the above are false and try again.\nA daily credit will not be used in 'No Data' cases.")
        ]);
  }
}

class _PlantIdResultsWidget extends StatelessWidget {
  const _PlantIdResultsWidget({required this.data});

  final PlantIdResponse data;

  @override
  Widget build(BuildContext context) {
    // When this widget is rendered, that means a successful response was given, so deduct from the Id for the day

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
          SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.idItems.length,
                itemBuilder: (context, index) {
                  return PlantIdCard(data: data.idItems[index]);
                }),
          ),
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
    // When this widget is build, a successful response was given. Subtract from the daily amount of heath assessments

    // Determine what the text and color of the health result text should be
    Color assessmentColor = Colors.green;
    String assessmentText = "Amazing";

    // MARK: Show the user the heath quality of their plant
    if (data.healthScorePercentage > 90) {
      assessmentText = "Amazing!";
      assessmentColor = Colors.blue;
    } else if (data.healthScorePercentage > 75) {
      assessmentText = "Well";
      assessmentColor = Colors.green;
    } else if (data.healthScorePercentage > 50) {
      assessmentText = "Unwell";
      assessmentColor = Colors.yellow;
    } else if (data.healthScorePercentage > 25) {
      assessmentText = "Terrible";
      assessmentColor = Colors.orange;
    } else if (data.healthScorePercentage > 10) {
      assessmentText = "Urgent";
      assessmentColor = Colors.deepOrange;
    } else if (data.healthScorePercentage > 0) {
      assessmentText = "Dead";
      assessmentColor = Colors.red;
    } else {
      assessmentText = "Unknown";
      assessmentColor = Theme.of(context).colorScheme.scrim;
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Health Assessment Generated (Gemini)",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            HorizontalRule(color: Theme.of(context).cardColor, height: 2),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(children: [
                Text("This plant appears to be..."),
                Text(
                  data.name.isNotEmpty ? data.name : "Unknown",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  data.scientificName.isNotEmpty
                      ? data.scientificName
                      : "Scientific name unknown",
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ]),
              Column(children: [
                Text(
                  "Health\nPercentage",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 0.8, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Stack(alignment: AlignmentDirectional.center, children: [
                  Text(
                    "${data.healthScorePercentage}%",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: CircularProgressIndicator(
                      value: data.healthScorePercentage.toDouble() / 100,
                      color: ThemeColors.teal1,
                      backgroundColor: Theme.of(context).hintColor,
                      semanticsValue: "${data.healthScorePercentage}%",
                      semanticsLabel: "Health Percentage",
                    ),
                  )
                ]),
                SizedBox(height: 10),
                Text(
                  assessmentText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      height: 0.8,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: assessmentColor),
                )
              ])
            ]),
            Text(""),
            Text(data.issueDescription),
            Text(data.solution),
            Text(data.prevention)
          ],
        ),
      ),
    );
  }
}

class _ResultLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Loading");
  }
}
