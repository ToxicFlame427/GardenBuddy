import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/gemini/plant_id_response.dart';
import 'package:garden_buddy/theming/colors.dart';

class PlantIdCard extends StatefulWidget {
  const PlantIdCard({super.key, required this.data});

  final IdItem data;

  @override
  State<PlantIdCard> createState() {
    return _PlantIdCardState();
  }
}

class _PlantIdCardState extends State<PlantIdCard> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          setState(() {
            showMore = !showMore;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(children: [
                    Stack(alignment: AlignmentDirectional.center, children: [
                      Text(
                        "${widget.data.idProbabliltyPercentage}%",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Transform.scale(
                        scale: 1.2,
                        child: CircularProgressIndicator(
                          value:
                              widget.data.idProbabliltyPercentage.toDouble() / 100,
                          color: ThemeColors.teal1,
                          backgroundColor: Theme.of(context).hintColor,
                          semanticsValue: "${widget.data.idProbabliltyPercentage}%",
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
                          widget.data.commonName!,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 22,
                              fontFamily: "Khand",
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.data.scientificName!,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.end,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Tap to show desription",
                          style:
                              TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if(showMore)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(widget.data.description!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
