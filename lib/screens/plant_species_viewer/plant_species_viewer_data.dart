import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/perenual/plant_species_details.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/image.dart' as NetworkImage;
import 'package:garden_buddy/widgets/formatting/horizontal_rule.dart';
import 'package:garden_buddy/widgets/variation_card.dart';
import 'package:shimmer/shimmer.dart';

class PlantSpeciesViewerData extends StatelessWidget {
  const PlantSpeciesViewerData({super.key, required this.plantData});

  final PlantSpeciesDetails? plantData;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(alignment: AlignmentDirectional.bottomCenter, children: [
            // Check if the image can be loaded. If not, show alt text
            if (plantData!.data.images.isNotEmpty)
              // MARK: Network image for API provided image
              NetworkImage.Image.network(
                plantData!.data.images[0].url,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text("Error retreiving image");
                },
              )
            else
              Text("No Image available"),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    VariationCard(label: plantData!.data.speciesOrVariety),
                    VariationCard(label: plantData!.data.growingCycle),
                  ]),
                  Padding(
                      padding: const EdgeInsets.all(2),
                      child: IconButton(
                          onPressed: () {
                            // Press to zoom
                          },
                          icon: Icon(Icons.zoom_in),
                          style: IconButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(175, 125, 125, 125),
                              iconSize: 22),
                          color: Colors.white))
                ])
          ]),

          // New column for better padding
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                // MARK: General info and description
                Text(plantData!.data.name,
                    style: Theme.of(context).textTheme.headlineLarge),
                Text(
                  plantData!.data.scientificName,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  plantData!.data.description,
                  style: TextStyle(fontSize: 13),
                ),
                HorizontalRule(color: Theme.of(context).cardColor, height: 5)
              ],
            ),
          )
        ],
      ),
    );
  }
}
