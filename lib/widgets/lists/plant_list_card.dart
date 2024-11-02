import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlantListCard extends StatelessWidget {
  const PlantListCard({super.key, required this.imageAddress, required this.plantName, required this.scientificName, required this.plantId});

  final String imageAddress;
  final String plantName;
  final String scientificName;
  final int plantId;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageAddress,
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
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plantName,
                      style: const TextStyle(
                          fontSize: 22,
                          fontFamily: "Khand",
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(scientificName)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
