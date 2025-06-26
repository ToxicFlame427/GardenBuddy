import 'package:flutter/material.dart';
import 'package:garden_buddy/models/db_models/db_scanner_results.dart';
import 'package:garden_buddy/models/services/db_services.dart';

class SavedScannerResults extends StatefulWidget {
  final String scannerType;

  const SavedScannerResults({super.key, required this.scannerType});

  @override
  State<StatefulWidget> createState() {
    return _SavedScannerResultsState();
  }
}

class _SavedScannerResultsState extends State<SavedScannerResults> {
  List<DBScannerResults> results = [];
  bool isLoaded = false;

  @override
  void initState() {
    if (!isLoaded) {
      _loadResults();
    }

    super.initState();
  }

  void _loadResults() async {
    results = await DbService.instance.getSavedScanResults(widget.scannerType);

    setState(() {
      isLoaded = true;
      results = results.reversed.toList();
    });

    debugPrint("$results");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Saved ${widget.scannerType}s",
            style: const TextStyle(
                color: Colors.white,
                fontFamily: "Khand",
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: false,
          iconTheme: const IconThemeData().copyWith(color: Colors.white),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Finish this widget tree boi! This is a basic skeleton of what it should look like.
            if (isLoaded)
              if (results.isEmpty)
                Text("There are no results")
              else
                Text("Data is found, display it here")
            else
              Text("Loading...")
          ],
        ));
  }
}
