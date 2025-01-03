import 'package:flutter/material.dart';
import 'package:garden_buddy/models/tool.dart';
import 'package:garden_buddy/screens/garden_ai_screen.dart';
import 'package:garden_buddy/screens/scanner_screen.dart';

class ToolCard extends StatelessWidget {
  const ToolCard({super.key, required this.toolObject});

  final Tool toolObject;

  void _navigateToScreen(BuildContext context) {
    switch(toolObject.title){
      case "Garden AI":
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const GardenAIScreen()));
        break;
      case "Plant Identification":
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ScannerScreen(scannerType: "Plant Identification")));
        break;
      case "Health Assessment":
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ScannerScreen(scannerType: "Health Assessment")));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: InkWell(
        onTap: () {
          _navigateToScreen(context);
        },
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: const BorderRadiusDirectional.only(
                  topStart: Radius.circular(20),
                  bottomStart: Radius.circular(20)),
              child: Image.asset(
                toolObject.image,
                width: 110,
                height: 110,
                fit: BoxFit.fill,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toolObject.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      toolObject.description,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
