import 'package:flutter/material.dart';

class SettingsFragment extends StatelessWidget {
  const SettingsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontFamily: "Khand",
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "App Information",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 30,
                    fontFamily: "Khand",
                    fontWeight: FontWeight.bold),
              ),
              Text("Developed by Koewen Hoffman (ToxicFlame427)")
            ]),
      ),
    );
  }
}
