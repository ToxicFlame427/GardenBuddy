import 'package:flutter/material.dart';
import 'package:garden_buddy/models/db_models/db_scanner_results.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/widgets/lists/saved_result_card.dart';
import 'package:garden_buddy/widgets/objects/no_saved_results.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // TODO: Finish this widget tree boi! This is a basic skeleton of what it should look like.
                  if (isLoaded)
                    if (results.isEmpty)
                      // Nothing has been saved
                      NoSavedResults()
                    else
                      // Saved data was found, display it
                      Expanded(
                        child: GridView.builder(
                            itemCount: results.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (ctx, index) {
                              return SavedResultCard(
                                resultObject: results[index],
                                scannerType: widget.scannerType,
                              );
                            }),
                      )
                  else
                    // The database results are still loading
                    Text("Loading...")
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (results.isNotEmpty)
                        FloatingActionButton(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () {
                              // TODO: Clear the list of saved results
                            })
                    ],
                  )
                ],
              )
            ]),
          ),
        ));
  }
}
