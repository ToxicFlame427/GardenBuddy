import 'package:flutter/material.dart';
import 'package:garden_buddy/gbio.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/screens/manage_subscription_screen.dart';
import 'package:garden_buddy/theming/colors.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/dialogs/loading_dialog.dart';
import 'package:garden_buddy/widgets/objects/credit_text_object.dart';
import 'package:garden_buddy/widgets/formatting/horizontal_rule.dart';
import 'package:garden_buddy/widgets/objects/hyperlink.dart';
import 'package:package_info_plus/package_info_plus.dart';

// Must be stateful for getting package details
class SettingsFragment extends StatefulWidget {
  const SettingsFragment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsFragmentState();
  }
}

class _SettingsFragmentState extends State<SettingsFragment> {
  // Blank for storing package information
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  // Get the package information
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _showResetAppDialog() async {
    showDialog(
        context: context,
        builder: (ctx) => ConfirmationDialog(
            title: "Reset Garden Buddy?",
            description:
                "WARNING: This function was made to give users the option to completely reset Garden Buddy. This means every on-device file managed by Garden Buddy will be deleted. These files include all favorited plants, AI chats, saved identifications and health assessments, along with cached data such as images. This cannot be undone. Users that are subscribed: your subscription status will stay in effect, only local device data for Garden Buddy will be affected.",
            imageAsset: "assets/icons/icon.jpg",
            positiveButtonText: "Reset",
            negativeButtonText: "No thanks",
            onNegative: () {
              Navigator.pop(context);
            },
            onPositive: () async {
              Navigator.pop(context);
              await _initAppReset();
            }));
  }

  Future<void> _showRestorePurchasesDialog() async {
    showDialog(
        context: context,
        builder: (ctx) => ConfirmationDialog(
            title: "Restore Purchases?",
            description:
                "This feature can be used to restore any purchases you have made from us. If a subscription does not activate, this button can also be clicked to activate it if it did not occur automatically.",
            imageAsset: "assets/icons/icon.jpg",
            positiveButtonText: "Restore",
            negativeButtonText: "No thanks",
            onNegative: () {
              Navigator.pop(context);
            },
            onPositive: () async {
              await _restorePurchases();

              if (mounted) {
                Navigator.pop(context);
              }
            }));
  }

  Future<void> _initAppReset() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return LoadingDialog(loadingText: "Resetting, please wait...");
        });

    await GBIO.resetApplication();

    if (mounted) {
      Navigator.pop(context);

      // Show that the aqpp reset was successful
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Application successfully reset!",
            style: TextStyle(
                color: Theme.of(context).colorScheme.scrim,
                fontWeight: FontWeight.bold)),
        duration: Duration(seconds: 2),
        backgroundColor: ThemeColors.green2,
      ));
    }
  }

  Future<void> _restorePurchases() async {
    await PurchasesApi.init();

    if (mounted) {
      await PurchasesApi.checkSubStatus(true, context);
    }
  }

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Settings",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // Send to Manage subscription page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  const ManageSubscriptionScreen()));
                    },
                    child: const Text(
                      "Manage Subscription",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      _showRestorePurchasesDialog();
                    },
                    child: const Text(
                      "Restore Purchases",
                      style: TextStyle(color: Colors.white),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text("App Information",
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                const CreditTextObject(
                    text: "Tool images provided by",
                    imagePath: "assets/icons/pixabay_icon.png",
                    linkText: "Pixabay",
                    url: "https://pixabay.com"),
                const CreditTextObject(
                    text:
                        "Garden AI,\nPlant Identification,\nand Health Assessment\nAI powered by",
                    imagePath: "assets/icons/gemini_icon.png",
                    linkText: "Gemini AI",
                    url: "https://deepmind.google/technologies/gemini/"),
                const CreditTextObject(
                    text: "Google Play feature\ngraphic created with",
                    imagePath: "assets/icons/hotpot_ai_icon.png",
                    linkText: "Hotpot AI",
                    url: "https://hotpot.ai/"),
                const CreditTextObject(
                    text: "In-app icons provided by",
                    imagePath: "assets/icons/icons8_logo.png",
                    linkText: "Icons8",
                    url: "https://icons8.com/"),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Text("Danger Zone",
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                    onPressed: () {
                      _showResetAppDialog();
                    },
                    child: const Text(
                      "Reset App",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                HorizontalRule(color: Colors.grey.shade500, height: 2),
                const Text("Developed by Koewen Hoffman (ToxicFlame427)"),
                Text("Version ${_packageInfo.version}"),
                const Hyperlink(
                    label: "Visit Our Website",
                    urlString: "https://toxicflame427.xyz"),
                const Hyperlink(
                    label: "Privacy Policy",
                    urlString:
                        "https://www.toxicflame427.xyz/pages/app_pages/garden_buddy/gb_privacy_policy.html"),
                const Hyperlink(
                    label: "Terms of Use",
                    urlString:
                        "https://www.toxicflame427.xyz/pages/app_pages/garden_buddy/gb_terms_of_use.html"),
              ]),
        ),
      ),
    );
  }
}
