import 'package:flutter/material.dart';

class GardenAIScreen extends StatefulWidget {
  const GardenAIScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GardenAIScreenState();
  }
}

class _GardenAIScreenState extends State<GardenAIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Garden AI"),
      ),
    );
  }
}
