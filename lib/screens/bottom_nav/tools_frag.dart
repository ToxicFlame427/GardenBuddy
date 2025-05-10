import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/models/tool.dart';
import 'package:garden_buddy/screens/garden_ai_screen.dart';
import 'package:garden_buddy/screens/plant_request_form.dart';
import 'package:garden_buddy/screens/scanner_screen.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/objects/banner_ad.dart';
import 'package:garden_buddy/widgets/lists/tool_card.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class ToolsFragment extends StatelessWidget {
  const ToolsFragment({super.key});

  // Show dialog about garden AI
  void _showBugReportDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: "Report a Bug?",
            description:
                "If you have spotted a bug, please let us know so we can fix this issue as soon as possible!",
            imageAsset: "assets/icons/icon.jpg",
            negativeButtonText: "No thanks!",
            positiveButtonText: "Report bug",
            onNegative: () {
              Navigator.pop(context);
            },
            onPositive: () {
              launchUrl(Uri.parse(
                  "https://www.toxicflame427.xyz/pages/bug_report.html"));
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    const List<Tool> toolArray = [
      Tool(
        image: "assets/icons/icon.jpg",
        title: "Garden AI",
        description: "Garden AI can answer your gardening questions"),
      Tool(
        image: "assets/icons/identify_icon.jpg",
        title: "Plant Identification",
        description: "Identify unknown plants by image"),
      Tool(
        image: "assets/icons/health_assessment_icon.jpg",
        title: "Health Assessment",
        description: "Assess your plant's health by image"),
      Tool(
        image: "assets/icons/plant_addon.jpg",
        title: "Request a Plant Addition",
        description: "Send us a request of a plant you want to see guides for!"),
      Tool(
        image: "assets/icons/caterpillar.jpg",
        title: "Report a Bug",
        description: "Found an app-breaking issue? Let us know!")
    ];

    return SafeArea(
      child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Helpful Tools",
                style: Theme.of(context).textTheme.headlineLarge
              ),
              ToolCard(
                toolObject: toolArray[0],
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const GardenAIScreen()));
                },
              ),
              ToolCard(
                toolObject: toolArray[1],
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ScannerScreen(scannerType: "Plant Identification")));
                }
              ),
              ToolCard(
                toolObject: toolArray[2],
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ScannerScreen(scannerType: "Health Assessment")));
                }
              ),
              ToolCard(
                toolObject: toolArray[3],
                onClick: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PlantRequestForm()));
                }
              ),
              ToolCard(
                toolObject: toolArray[4],
                onClick: (){
                  _showBugReportDialog(context);
                }
              ),
              // MARK: THESE ARE REAL IDS, DONT TOUCH
              BannerAdView(
                androidBannerId:
                  "ca-app-pub-6754306508338066/2146896939",
                iOSBannerId:
                  "ca-app-pub-6754306508338066/1392308067",
                isTest: adTesting,
                isShown: !PurchasesApi.subStatus,
                bannerSize: AdSize.banner,
              ),
            ]
          ),
        ),
    );
  }
}
