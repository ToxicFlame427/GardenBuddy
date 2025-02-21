import 'package:flutter/material.dart';
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
              ElevatedButton(onPressed: () {
                // TODO: Send the request somewhere!
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white
                ),
              ),),
              Spacer(),
              Text(
                "These submissions are anonymous, as no contact details need to be provided.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20,)
            ],
          ),
        ));
  }
}
