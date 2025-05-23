import 'dart:io';

import 'package:flutter/material.dart';
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
                  if (imageAddress!.contains("http://") || imageAddress!.contains("https://"))
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          imageAddress!,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 90,
                                width: 90,
                                color: Colors.grey,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icons/hand_plant_icon.png",
                              height: 90,
                              width: 90,
                            );
                          },
                        ))
                  else
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(imageAddress!),
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icons/hand_plant_icon.png",
                              height: 90,
                              width: 90,
                            );
                          },
                        ))
                else
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        "assets/icons/hand_plant_icon.png",
                        height: 90,
                        width: 90,
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
                        style: const TextStyle(
                            fontSize: 22,
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
