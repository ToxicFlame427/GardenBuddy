import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/gemini/plant_id_response.dart';
import 'package:garden_buddy/theming/colors.dart';

class PlantIdCard extends StatelessWidget {
  const PlantIdCard({super.key, required this.data});

  final IdItem data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(children: [
              Stack(alignment: AlignmentDirectional.center, children: [
                Text(
                  "${data.idProbabliltyPercentage}%",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: CircularProgressIndicator(
                    value: data.idProbabliltyPercentage.toDouble() / 100,
                    color: ThemeColors.teal1,
                    backgroundColor: Theme.of(context).hintColor,
                    semanticsValue: "${data.idProbabliltyPercentage}%",
                    semanticsLabel: "Match probability",
                  ),
                )
              ]),
              SizedBox(height: 10),
              Text(
                "Match\nProbability",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 0.8, fontSize: 12, fontWeight: FontWeight.w500),
              )
            ]),
            SizedBox(width: 10),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data.commonName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        fontSize: 22,
                        fontFamily: "Khand",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    data.scientificName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Tap to show more",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
