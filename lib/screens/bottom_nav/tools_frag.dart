import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/models/tool.dart';
import 'package:garden_buddy/widgets/banner_ad.dart';
import 'package:garden_buddy/widgets/lists/tool_card.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
            ToolCard(toolObject: toolArray[2]),
            // MARK: THESE ARE REAL IDS, DONT TOUCH
            BannerAdView(
              androidBannerId:
                "ca-app-pub-6754306508338066/2146896939",
              iOSBannerId:
                "ca-app-pub-6754306508338066/1392308067",
              isTest: adTesting,
              isShown: !PurchasesApi.subStatus,
              bannerSize: AdSize.mediumRectangle,
            ),
          ]
        ),
      ),
    );
  }
}
