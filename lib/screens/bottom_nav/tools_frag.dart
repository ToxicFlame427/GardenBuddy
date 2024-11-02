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
            Text(
              "Helpful Tools",
              style: Theme.of(context).textTheme.headlineLarge
            ),
            ToolCard(toolObject: toolArray[0]),
            ToolCard(toolObject: toolArray[1]),
            ToolCard(toolObject: toolArray[2])
          ]
        ),
      ),
    );
  }
}
