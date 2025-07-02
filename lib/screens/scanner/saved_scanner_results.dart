import 'package:flutter/material.dart';
import 'package:garden_buddy/models/db_models/db_scanner_results.dart';
import 'package:garden_buddy/models/services/db_services.dart';
import 'package:garden_buddy/screens/scanner/scanner_results_screen.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/lists/saved_result_card.dart';
import 'package:garden_buddy/widgets/objects/no_saved_results.dart';
import 'package:image_picker/image_picker.dart';

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

  void _navigateToOfflineResults(DBScannerResults resultObject) async {
    // Await the result from PlantSpeciesViewer
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (ctx) => ScannerResultScreen(
                picture: XFile(resultObject.localImageDir),
                scannerType: widget.scannerType,
                fromSaved: true,
                resultsObject: resultObject,
              )),
    );

    // Check if the result indicates a change and the widget is still mounted
    if (result == true && mounted) {
      // If results were changed, reload the list
      _loadResults();
    }
  }

  void _showClearSavedResultsDialog() {
    showDialog(
        context: context,
        builder: (ctx) => ConfirmationDialog(
            title: "Clear Saved Results?\n(${widget.scannerType})",
            description:
                "This action cannot be undone. This will clear all of the saved results of this particular type from your device. Do you want to proceed?",
            imageAsset: "assets/icons/icon.jpg",
            positiveButtonText: "Clear",
            negativeButtonText: "No thanks",
            onNegative: () {
              Navigator.pop(context);
            },
            onPositive: () async {
              if (widget.scannerType == "Plant Identification") {
                await DbService.instance.nukeIdTable();
              } else {
                await DbService.instance.nukeHaTable();
              }

              _loadResults();

              if (mounted) {
                Navigator.pop(context);
              }
            }));
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
                                onTap: () {
                                  _navigateToOfflineResults(results[index]);
                                },
                              );
                            }),
                      )
                  else
                    // The database results are still loading
                    Center(child: Text("Fetching saved data..."))
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
                              _showClearSavedResultsDialog();
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
