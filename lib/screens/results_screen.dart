import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
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

  // Used to send the prompt to the Gemini model
  Future<void> sendPrompt() async {
    TextPart prompt;
    Uint8List imagebytes = await widget.picture.readAsBytes();

    // Determine the correct prompt to send based on what scanner is being used
    if (widget.scannerType == "Plant Identification") {
      prompt = TextPart("What plant is this? Can you tell me a bit about it?");
    } else {
      prompt = TextPart("How healthy is this plant? What can I do to help it?");
    }

    var getter = await aiModel.generateContent([
      Content.multi(
          // Assuming that the image has a defines MIME type
          [prompt, DataPart("image/jpeg", imagebytes)])
    ]);

    // Set the state on response
    setState(() {
      response = getter.text;
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
          if (recievedResult) Text(response!) else _ResultLoading()
        ],
      ),
    );
    // For displaying the image: Image.file(File(widget.picture.path));
  }
}

class _ResultLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Loading");
  }
}
