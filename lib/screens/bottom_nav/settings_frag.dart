
import 'package:flutter/material.dart';
import 'package:garden_buddy/screens/manage_subscription_screen.dart';
import 'package:garden_buddy/widgets/credit_text_object.dart';
import 'package:garden_buddy/widgets/horizontal_rule.dart';
import 'package:garden_buddy/widgets/hyperlink.dart';

class SettingsFragment extends StatelessWidget {
  const SettingsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => const ManageSubscriptionScreen()));
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
                    // TODO: Open dialog to confirm app leave
                  },
                  child: const Text(
                    "Report a bug",
                    style: TextStyle(color: Colors.white),
                  )
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: Text(
                  "App Information",
                  style: Theme.of(context).textTheme.headlineLarge),
              ),
              const CreditTextObject(
                  text: "Tool images provided by",
                  imagePath: "assets/icons/pixabay_icon.png",
                  linkText: "Pixabay",
                  url: "https://pixabay.com"),
              const CreditTextObject(
                  text: "Plant and disease\ndata provided by",
                  imagePath: "assets/icons/perenual_icon.png",
                  linkText: "Perenual",
                  url: "https://perenual.com"),
              const CreditTextObject(
                  text:
                      "Garden AI,\nPlant Identification,\nand Health Assessment\nAI powered by",
                  imagePath: "assets/icons/gemini_icon.png",
                  linkText: "Gemini AI",
                  url: "https://deepmind.google/technologies/gemini/"),
              const CreditTextObject(
                  text: "Google Play feature\ngraphic created with",
                  imagePath: "assets/icons/hand_plant_icon.png",
                  linkText: "Hotpot AI",
                  url: "https://hotpot.ai/"),
              HorizontalRule(color: Colors.grey.shade500, height: 2),
              const Text("Developed by Koewen Hoffman (ToxicFlame427)"),
              const Text("Version name - "),
              const Text("Update revision - v"),
              const Hyperlink(
                  label: "Visit Our Website",
                  urlString: "https://toxicflame427.xyz"),
              const Hyperlink(
                  label: "Privacy Policy",
                  urlString:
                      "https://toxicflame427.xyz/privacy_policies/privacy_policy_website.html")
            ]),
      ),
    );
  }
}
