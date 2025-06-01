import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart'
    // ignore: library_prefixes
    as PlantDetailsClass;
// ignore: implementation_imports, library_prefixes
import 'package:flutter/src/widgets/image.dart' as NetworkImage;
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/widgets/dialogs/custom_info_dialog.dart';
import 'package:garden_buddy/widgets/dialogs/image_info_dialog.dart';
import 'package:garden_buddy/widgets/objects/banner_ad.dart';
import 'package:garden_buddy/widgets/objects/bold_label_row.dart';
import 'package:garden_buddy/widgets/objects/five_way_meter.dart';
import 'package:garden_buddy/widgets/formatting/horizontal_rule.dart';
import 'package:garden_buddy/widgets/objects/lifecycle_object.dart';
import 'package:garden_buddy/widgets/objects/variation_card.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class PlantSpeciesViewerData extends StatelessWidget {
  const PlantSpeciesViewerData({super.key, required this.plantData});

  final PlantDetailsClass.PlantSpeciesDetails? plantData;

  @override
  Widget build(BuildContext context) {
    void showInfoDialog(String title, String message) {
      showDialog(
          context: context,
          builder: (ctx) {
            return CustomInfoDialog(
                title: title,
                description: message,
                imageAsset: "assets/icons/icon.jpg",
                buttonText: "Ok",
                onClose: () {
                  Navigator.pop(context);
                });
          });
    }

    void showImageDialog(PlantDetailsClass.Image imageData) {
      showDialog(
          context: context,
          builder: (ctx) {
            return ImageInfoDialog(imageData: imageData);
          });
    }

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
              if (plantData!.data.images[0].url.contains("http://") ||
                  plantData!.data.images[0].url.contains("https://"))
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
              else if (!plantData!.data.images[0].url.contains("http://") &&
                  !plantData!.data.images[0].url.contains("https://"))
                NetworkImage.Image.file(
                  File(plantData!.data.images[0].url),
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Text("Error retreiving image");
                  },
                )
              else
                SizedBox(height: 50, child: Text("No Image available"))
            else
              SizedBox(height: 50, child: Text("No Image available")),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [
                    VariationCard(
                      label: plantData!.data.speciesOrVariety,
                      onTap: () {},
                    ),
                    VariationCard(
                      label: plantData!.data.growingCycle,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (ctx) => CustomInfoDialog(
                                title: "Growing Cycle",
                                description:
                                    "Growing cycles are an indicator of how long the entire lifecycle of a plant takes place, typically in one of these three categories:\n\nPerennial - Lives for more than two years. Flowers and seeds over multiple seasons.\n\nBiennial - Two growing cycles, typically 2 years\n\nAnnual - One growing cycle, typically 1 year",
                                imageAsset: "assets/icons/icon.jpg",
                                buttonText: "Okay",
                                onClose: () {
                                  Navigator.of(context).pop();
                                }));
                      },
                    ),
                    if (!(plantData!.data.patentStatus
                            .toLowerCase()
                            .contains("none")) &&
                        !(plantData!.data.patentStatus
                            .toLowerCase()
                            .contains("unknown")))
                      VariationCard(
                        label: "Patent: ${plantData!.data.patentStatus}",
                        isPatent: true,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (ctx) => CustomInfoDialog(
                                  title: "Patented Plant",
                                  description:
                                      "Some varieties of plants are patented. Patents protect these plants as intellectual property and outline usage of the variety:\n\nPVP (Plant Variety Protection): The plant can be homegrown, however cannot be grown commercially, sold/traded as seed/crop, or bred into hybrids without patent owners' consent.\n\nOther patents tend to follow these same rules, particularly getting permission to do anything with the plant from the patent owner.",
                                  imageAsset: "assets/icons/icon.jpg",
                                  buttonText: "Okay",
                                  onClose: () {
                                    Navigator.of(context).pop();
                                  }));
                        },
                      )
                  ]),
                  if (plantData!.data.images.isNotEmpty)
                    Padding(
                        padding: const EdgeInsets.all(2),
                        child: IconButton(
                            onPressed: () {
                              // MARK: Show the image info dialog
                              showImageDialog(plantData!.data.images.first);
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
                  "Other Names",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plantData!.data.otherNames.length,
                    itemBuilder: (ctx, i) {
                      return Text(plantData!.data.otherNames[i]);
                    }),

                BannerAdView(
                    androidBannerId: "ca-app-pub-6754306508338066/1797528673",
                    iOSBannerId: "ca-app-pub-6754306508338066/6837731855",
                    isTest: adTesting,
                    isShown: !PurchasesApi.subStatus,
                    bannerSize: AdSize.mediumRectangle),
                Text(
                  plantData!.data.description,
                  style: TextStyle(fontSize: 13),
                ),
                HorizontalRule(color: Theme.of(context).cardColor, height: 5),
                // MARK: Value Meters
                Text(
                  "Meters",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                FiveWayMeter(
                    onInfoTap: () {
                      showInfoDialog("Maintenance Level",
                          "What does this mean?\n\nThis is for indicating how much time needs to be devoted to making this plant its healthiest. A low level means it can take care of itself with little assistance, but high levels mean it requires more human assistance to be healthy.");
                    },
                    value: plantData!.data.maintenanceLevel,
                    label: "Maintenance level"),
                FiveWayMeter(
                    onInfoTap: () {
                      showInfoDialog("Growth Rate",
                          "What does this mean?\n\nThis meter is for displaying how fast this plant grows. The lower the meter score, the slower this plant tends to grow. The higher the meter score, the faster the plant grows. This is generalized data relative to all plants as some plants tend to grow slower/faster than others.");
                    },
                    value: plantData!.data.growthRate,
                    label: "Growth rate"),
                HorizontalRule(color: Theme.of(context).cardColor, height: 5),
                // MARK: Lifecycle
                Text(
                  "Lifecycle",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                LifeCycleObject(
                  label: "Seeds",
                  imageAsset: "assets/icons/seeds.png",
                  content: [
                    Text(
                      "This plant is grown from",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Display the correct information here
                    if (plantData!.data.hasCorms) Text("Corms / Bulbs"),
                    if (plantData!.data.hasSeeds) Text("Seeds"),
                    SizedBox(
                      height: 15,
                    ),
                    BoldLabelRow(
                        label: "Plant spacing",
                        data:
                            "${plantData!.data.plantSpacing.value} ${plantData!.data.plantSpacing.unit}"),
                    BoldLabelRow(
                        label: "Germination time",
                        data:
                            "${plantData!.data.seedGerminationTime.time} ${plantData!.data.seedGerminationTime.unit}"),
                  ],
                ),
                // MARK: Maturing
                SizedBox(
                  height: 20,
                ),
                LifeCycleObject(
                  label: "Maturing",
                  imageAsset: "assets/icons/plant.png",
                  content: [
                    BoldLabelRow(
                        label: "Maturity time",
                        data:
                            "${plantData!.data.maturityTime.time} ${plantData!.data.maturityTime.unit}"),
                    BoldLabelRow(
                        label: "Average mature spread",
                        data:
                            "${plantData!.data.averageSpread.value} ${plantData!.data.averageSpread.unit}"),
                    BoldLabelRow(
                        label: "Average mature height",
                        data:
                            "${plantData!.data.averageHeight.value} ${plantData!.data.averageHeight.unit}"),
                    BoldLabelRow(
                      label: "Grows flowers",
                      data: plantData!.data.hasFlowers ? "Yes" : "No",
                    ),
                    if (plantData!.data.hasFlowers)
                      BoldLabelRow(
                        label: "Flowering Seasons",
                        data: plantData!.data.floweringSeason,
                      ),
                  ],
                ),

                if (plantData!.data.hasFlowers)
                  Text(
                    "Flowering Months",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                if (plantData!.data.hasFlowers)
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: plantData!.data.floweringMonths.length,
                      itemBuilder: (ctx, i) {
                        return Text(plantData!.data.floweringMonths[i]);
                      }),
                BannerAdView(
                    androidBannerId: "ca-app-pub-6754306508338066/1797528673",
                    iOSBannerId: "ca-app-pub-6754306508338066/6837731855",
                    isTest: adTesting,
                    isShown: !PurchasesApi.subStatus,
                    bannerSize: AdSize.largeBanner),
                // MARK: PLANT GUIDES
                HorizontalRule(color: Theme.of(context).cardColor, height: 5),
                Text(
                  "Plant Guides",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(children: [
                  Image.asset(
                    "assets/icons/sowing.png",
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Sowing",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ]),

                Text(
                  "Planting Months",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plantData!.data.plantingMonths.length,
                    itemBuilder: (ctx, i) {
                      return Text(plantData!.data.plantingMonths[i]);
                    }),
                BoldLabelRow(
                    label: "Planting seasons",
                    data: plantData!.data.plantingSeason),
                BoldLabelRow(label: "Soil pH", data: plantData!.data.soilPh),
                BoldLabelRow(
                    label: "Preferred sunlight",
                    data: plantData!.data.preferredSunlight.first),
                Text(
                  "Plants should be spaced ${plantData!.data.plantSpacing.value} ${plantData!.data.plantSpacing.unit} apart.",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // TODO: Prefered soil
                // Prefered sunlight
                SizedBox(
                  height: 10,
                ),
                Text(plantData!.data.sowingGuide),
                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Image.asset(
                    "assets/icons/pruning.png",
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Pruning",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ]),
                Text(plantData!.data.pruningGuide),
                SizedBox(
                  height: 15,
                ),

                Row(children: [
                  Image.asset(
                    "assets/icons/watering.png",
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Watering",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ]),
                Text(plantData!.data.wateringGuide),

                SizedBox(
                  height: 15,
                ),
                Row(children: [
                  Image.asset(
                    "assets/icons/harvest.png",
                    height: 35,
                    width: 35,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Harvesting",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ]),

                Text(
                  "Harvest Months",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: plantData!.data.harvestMonths.length,
                    itemBuilder: (ctx, i) {
                      return Text(plantData!.data.harvestMonths[i]);
                    }),

                BoldLabelRow(
                    label: "Harvest Seasons",
                    data: plantData!.data.harvestSeason),
                SizedBox(
                  height: 10,
                ),
                Text(plantData!.data.harvestingGuide),

                // MARK: Extra Information
                HorizontalRule(color: Theme.of(context).cardColor, height: 5),
                Text(
                  "Extra Info",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                BoldLabelRow(
                    label: "Container friendly",
                    data: plantData!.data.containerFriendly ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Indoor friendly",
                    data: plantData!.data.containerFriendly ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Frost tolerant",
                    data: plantData!.data.frostTolerant ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Heat tolerant",
                    data: plantData!.data.heatTolerant ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Salt tolerant",
                    data: plantData!.data.saltTolerant ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Produces seeds",
                    data: plantData!.data.hasSeeds ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Produces flowers",
                    data: plantData!.data.hasFlowers ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Produces corms / bulbs",
                    data: plantData!.data.hasCorms ? "Yes" : "No"),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "IMPORTANT: Do not taste nature without professional confirmation!",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      height: 0.85),
                ),
                BoldLabelRow(
                    label: "Poisonous to humans",
                    data: plantData!.data.poisonousToHumans ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Poisonous to pets",
                    data: plantData!.data.poisonousToPets ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Leaves are edible",
                    data: plantData!.data.leavesAreEdible ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Seeds are edible",
                    data: plantData!.data.seedsAreEdible ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Fruits are edible",
                    data: plantData!.data.fruitIsEdible ? "Yes" : "No"),
                BoldLabelRow(
                    label: "Used in medicine",
                    data: plantData!.data.medicinal ? "Yes" : "No"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
