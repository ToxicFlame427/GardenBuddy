import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:garden_buddy/models/api/gemini/ai_constants.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/screens/manage_subscription_screen.dart';
import 'package:garden_buddy/screens/scanner/scanner_results_screen.dart';
import 'package:garden_buddy/screens/scanner/saved_scanner_results.dart';
import 'package:garden_buddy/widgets/dialogs/confirmation_dialog.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';
import 'package:garden_buddy/widgets/objects/credit_circle.dart';
import 'package:garden_buddy/widgets/dialogs/custom_info_dialog.dart';
import 'package:garden_buddy/widgets/objects/picture_quality_card.dart';
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.scannerType});

  final String scannerType;

  @override
  State<StatefulWidget> createState() {
    return _ScannerScreenState();
  }
}

class _ScannerScreenState extends State<ScannerScreen> {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  int creditsChanged = 0;

  @override
  void initState() {
    // Initialize the camer upon loading
    _setupCameraController();
    super.initState();
  }

  @override
  void dispose() {
    // As long as the cmaer controller is not null, dispose of the camera after the state ends
    if (cameraController != null) {
      cameraController!.dispose();
    }
    super.dispose();
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      // Set the flash to be turned off if the camera controller is not null
      setState(() {
        cameras = cameras;
        // _cameras.first = Front camera, _camera.last = Back camera
        if (cameras.first.lensDirection == CameraLensDirection.back) {
          cameraController = CameraController(
              cameras.first, ResolutionPreset.high,
              enableAudio: false);
        } else if (cameras.last.lensDirection == CameraLensDirection.back) {
          cameraController = CameraController(
              cameras.last, ResolutionPreset.high,
              enableAudio: false);
        } else {
          cameraController = CameraController(
              cameras.first, ResolutionPreset.high,
              enableAudio: false);
        }
      });

      cameraController?.initialize().then((_) {
        setState(() {
          if (cameraController != null) {
            cameraController!.setFlashMode(FlashMode.off);
          }
        });
      });
    }
  }

  // This function awaits for changes to the results screen to update the credit count
  void _navigateToResults(XFile file) async {
    // Await the result from PlantSpeciesViewer
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScannerResultScreen(
                picture: file, scannerType: widget.scannerType, fromSaved: false,)));

    // Check if the result indicates a change and the widget is still mounted
    if (result == true && mounted) {
      // If credits were changed, reload the values
      setState(() {
        AiConstants.aiCount = AiConstants.aiCount;
        AiConstants.healthCount = AiConstants.healthCount;
      });
    }
  }

  void _showScannerDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomInfoDialog(
              title: widget.scannerType == "Plant Identification"
                  ? "About Plant ID"
                  : "About Health Assess",
              description: widget.scannerType == "Plant Identification"
                  ? "Plant identifications are powered by Garden AI and will generate a textual response. Please note that as this is powered by an AI model, it is not completely accurate. For this reason, each generation has a regenerate button for responses that may not be accurate. Please do not rely on this response alone and DO NOT taste nature without professional confirmation!"
                  : "Plant health assessments are powered by Garden AI and will generate a textual response. Please note that as this is powered by an AI model, it is not completely accurate. For this reason, each generation has a regenerate button for responses that may not be accurate. Please do not rely on this response alone. Some responses from heath assessments may suggest you to see a plant expert. This means that the cause of the issue is unknown or unclear in the image.",
              imageAsset: "assets/icons/icon.jpg",
              buttonText: "Got it!",
              onClose: () {
                Navigator.pop(context);
              });
        });
  }

  Widget _conditionalCamera() {
    // Return the camera view if the controller is initialized correctly
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.grey.shade400,
              size: 50,
            ),
            Text(
              "There is no camera available\nat this moment.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                  fontSize: 20),
            )
          ],
        ),
      );
    }

    final mediaSize = MediaQuery.of(context).size;
    final controller =
        cameraController!; // Already checked for null and initialized

    // Ensure previewSize is available from the controller
    if (controller.value.previewSize == null) {
      return const Center(
          child: Text("Camera preview size is not available yet.",
              style: TextStyle(color: Colors.white)));
    }

    return Container(
      width: mediaSize.width,
      height: mediaSize.height,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 1,
        child: SizedBox(
          width: controller.value.previewSize!.width,
          height: controller.value.previewSize!.height,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  void _showMissingCreditsDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return ConfirmationDialog(
            title: "Out of credits!",
            description:
                "It appears that you have ran out of credits to use our scanner featues. You must wait until tomorrow for one credit or you can subscribe for unlimited credits.",
            imageAsset: "assets/icons/icon.jpg",
            negativeButtonText: "No thanks!",
            positiveButtonText: "Subscribe",
            onNegative: () {
              Navigator.pop(context);
            },
            onPositive: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => const ManageSubscriptionScreen()));
            },
          );
        });
  }

  // Check if the user can do another scan granted that they have no subscription and credits remain
  bool _canDoScan() {
    if (!PurchasesApi.subStatus) {
      if (widget.scannerType == "Plant Identification") {
        if (AiConstants.idCount <= 0) {
          return false;
        } else {
          return true;
        }
      } else {
        if (AiConstants.healthCount <= 0) {
          return false;
        } else {
          return true;
        }
      }
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    double buttonTextSize = 14;
    double buttonIconSize = 30;

    // determine compatability sizes
    if (Responsive.isSmallPhone(context)) {
      buttonTextSize = 12;
      buttonIconSize = 24;
    } else if (Responsive.isTablet(context)) {
      buttonTextSize = 16;
      buttonIconSize = 36;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.scannerType,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: "Khand",
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: false,
        actions: [
          CreditCircle(
              value: widget.scannerType == "Plant Identification"
                  ? AiConstants.idCount
                  : AiConstants.healthCount),
          IconButton(
            onPressed: _showScannerDialog,
            icon: const Icon(Icons.info),
            color: Colors.white,
          )
        ],
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Transform used to make the preview be in fullscreen
          // Todo
          _conditionalCamera(),
          SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Best practices card
              const PictureQualityCard(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_canDoScan()) {
                            // User picks an image from gallery
                            // Open the results screen by passing the chosen image
                            ImagePicker picker = ImagePicker();
                            XFile? file = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (file != null) {
                              await Future.delayed(const Duration(seconds: 1));

                              if (context.mounted) {
                                _navigateToResults(file);
                              }
                            }
                          } else {
                            _showMissingCreditsDialog();
                          }
                          // Else, do nothing
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                                size: buttonIconSize,
                              ),
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: buttonTextSize),
                            ),
                          ],
                        )),
                    // Button to navigate to the saved results screen
                    // Only show this button if the user is subscribed
                    if (PurchasesApi.subStatus)
                      ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => SavedScannerResults(
                                        scannerType: widget.scannerType)));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.save,
                                  color: Colors.white,
                                  size: buttonIconSize,
                                ),
                              ),
                              Text(
                                "Saved",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: buttonTextSize),
                              ),
                            ],
                          )),
                    ElevatedButton(
                        onPressed: () async {
                          if (_canDoScan()) {
                            // Image is captured
                            // Open the results screen shortly after and pass the captured image to it
                            XFile picture =
                                await cameraController!.takePicture();

                            if (context.mounted) {
                              _navigateToResults(picture);
                            }
                          } else {
                            _showMissingCreditsDialog();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.camera,
                                color: Colors.white,
                                size: buttonIconSize,
                              ),
                            ),
                            Text(
                              "Take",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: buttonTextSize),
                            ),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
