import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garden_buddy/models/db_models/db_scanner_results.dart';

class SavedResultCard extends StatelessWidget {
  const SavedResultCard(
      {super.key,
      required this.resultObject,
      required this.scannerType,
      required this.onTap});

  final DBScannerResults resultObject;
  final String scannerType;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: Image.file(
                    File(resultObject.localImageDir),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset("assets/icons/hand_plant_icon.png");
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  resultObject.date,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
