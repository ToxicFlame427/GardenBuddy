import 'package:flutter/material.dart';
import 'package:garden_buddy/models/tool.dart';
import 'package:garden_buddy/widgets/lists/tool_card.dart';

class ToolsFragment extends StatelessWidget {
  const ToolsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Helpful Tools",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 30,
                fontFamily: "Khand",
                fontWeight: FontWeight.bold
            ),),
            ToolCard(toolObject: toolArray[0]),
            ToolCard(toolObject: toolArray[1]),
            ToolCard(toolObject: toolArray[2])
          ]
        ),
      ),
    );
  }
}
