import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/credit_circle.dart';
import 'package:garden_buddy/widgets/custom_info_dialog.dart';

class GardenAIScreen extends StatefulWidget {
  const GardenAIScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GardenAIScreenState();
  }
}

class _GardenAIScreenState extends State<GardenAIScreen> {
  // Show dialog about garden AI
  void _showGardenAIDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomInfoDialog(
              title: "Say Hello to Garden AI!",
              description: "Garden AI is here to help you tend to your garden! Ask Garden AI any question about gardening, lawncare, or landscaping and it is sure to give you an answer! Please note that this is an AI model, and not every reponse is completely accurate. Please be aware of this and believe what you will. To begin, send a chat message.",
              imageAsset: "assets/icons/icon.jpg",
              buttonText: "Got it!",
              onClose: () {
                Navigator.pop(context);
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Garden AI",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: false,
        actions: [
          const CreditCircle(value: 3),
          IconButton(
            onPressed: _showGardenAIDialog,
            icon: const Icon(Icons.info),
            color: Colors.white,
          )
        ],
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
      body: const Text("Garden AI Body"),
    );
  }
}
