import 'dart:math';

import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/garden_api/add_plant_request_model.dart';
import 'package:garden_buddy/models/services/garden_api_services.dart';
import 'package:garden_buddy/widgets/dialogs/loading_dialog.dart';
import 'package:garden_buddy/widgets/objects/gb_text_field.dart';

class PlantRequestForm extends StatefulWidget {
  const PlantRequestForm({super.key});

  @override
  State<PlantRequestForm> createState() {
    return _PlantRequestFormState();
  }
}

class _PlantRequestFormState extends State<PlantRequestForm> {
  TextEditingController plantNameController = TextEditingController();
  bool? formSentSuccessful;

  @override
  Widget build(BuildContext context) {
    // This ain no fkn construction site! Scaffolds fkn everywhere!
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Request a Plant Addition",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Khand",
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: false,
          iconTheme: const IconThemeData().copyWith(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "If there is a plant you want to see guides for here on Garden Buddy, please fill out the form below! If there are multiple, seperate them with a comma (,).",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.scrim,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 150,
                child: GbTextfield(
                  hint: "Plants",
                  controller: plantNameController,
                  multiline: true,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  sendForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              // Only show this text after a request is sent
              if (formSentSuccessful != null)
                SizedBox(
                  height: 10,
                ),
              if (formSentSuccessful != null)
                Text(
                  formSentSuccessful!
                      ? "Request was successfully sent. We appreciate your requests and will review it soon!"
                      : "Request failed to send. Please try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: formSentSuccessful! ? Colors.green : Colors.red),
                ),
              Spacer(),
              Text(
                "These submissions are anonymous, as no contact details need to be provided.",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }

  void sendForm() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return LoadingDialog(loadingText: "Sending form\nplease wait...");
        });

    formSentSuccessful = await GardenAPIServices.sendPlantRequestForm(
        AddPlantRequestModel(
            id: Random(DateTime.now().millisecond)
                .nextInt(4294967296)
                .toString(),
            dateSubmitted: DateTime.now().toIso8601String(),
            requestedPlants: plantNameController.text));

    // So like, this sucks
    // SO this is pretty cool: to use context over async gaps, just simply make a mounted check
    if (mounted) {
      // Did the mount, bust still getting the warning?
      Navigator.of(context).pop();

      setState(() {
        plantNameController.text = "";
      });
    } else {
      return;
    }
  }
}
