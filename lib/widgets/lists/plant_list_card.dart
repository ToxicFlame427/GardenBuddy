import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';
import 'package:shimmer/shimmer.dart';

class PlantListCard extends StatelessWidget {
  const PlantListCard(
      {super.key,
      required this.imageAddress,
      required this.plantName,
      required this.scientificName,
      required this.plantId,
      required this.onTapAction});

  final String? imageAddress;
  final String plantName;
  final String scientificName;
  final int plantId;
  final Function onTapAction;

  @override
  Widget build(BuildContext context) {
    // Default sizes
    double imageSize = 90;
    double textsize = 22;

    // Conditional sizes
    if (Responsive.isSmallPhone(context)) {
      imageSize = 75;
      textsize = 18;
    } else if (Responsive.isLargeTablet(context)) {
      imageSize = 110;
      textsize = 26;
    }

    return Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            onTapAction();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (imageAddress != null)
                  if (imageAddress!.contains("http://") ||
                      imageAddress!.contains("https://"))
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageAddress!,
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: imageSize,
                                width: imageSize,
                                color: Colors.grey,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icons/hand_plant_icon.png",
                              height: imageSize,
                              width: imageSize,
                            );
                          },
                        ))
                  else
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imageAddress!),
                          height: imageSize,
                          width: imageSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icons/hand_plant_icon.png",
                              height: imageSize,
                              width: imageSize,
                            );
                          },
                        ))
                else
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/icons/hand_plant_icon.png",
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.cover,
                      )),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plantName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: textsize,
                            fontFamily: "Khand",
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        scientificName,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
