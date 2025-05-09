import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart';
import 'package:garden_buddy/widgets/formatting/horizontal_rule.dart';
import 'package:garden_buddy/widgets/objects/bold_label_row.dart';
import 'package:garden_buddy/widgets/objects/gb_text_field.dart';

class PlantEditRequestScreen extends StatefulWidget {
  const PlantEditRequestScreen({super.key, required this.plantDetails});

  final PlantSpeciesDetails plantDetails;

  @override
  State<StatefulWidget> createState() {
    return _PlantEditRequestState();
  }
}

// Ok, I have a really nice idea. When the user changes certain values, update them in the pdVariable.
// If they decide to submit it, then the data is already formatted and ready to be sent to the server
class _PlantEditRequestState extends State<PlantEditRequestScreen> {
  @override
  Widget build(BuildContext context) {
    PlantSpeciesDetails pd = widget.plantDetails;

    // Oh my controllers!
    TextEditingController sciNameController = TextEditingController();
    sciNameController.text = pd.data.scientificName;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Request Edit - ${pd.data.name}",
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
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Is there some incorrect information on this page? Request an edit by making changes here! We dont know everything, and there are destined to be mistakes. Please let us know if something is incorrect!",
              textAlign: TextAlign.center,
            ),
            HorizontalRule(color: Theme.of(context).cardColor, height: 2),
            // MARK: Unchangable information
            Text(
              "General Info (Cannot change)",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            BoldLabelRow(
                label: "API Identifier", data: pd.data.apiId.toString()),
            BoldLabelRow(label: "Name", data: pd.data.name.toString()),
            SizedBox(
              height: 16,
            ),
            // MARK: Changable information
            Text(
              "Changable Information",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 5,
            ),
            GbTextfield(
                hint: "Scientific Name",
                controller: sciNameController,
                multiline: false),
          ],
        ),
      ),
    );
  }
}
