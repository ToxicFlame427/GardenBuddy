import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:garden_buddy/screens/results_screen.dart';
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
          cameraController =
              CameraController(cameras.first, ResolutionPreset.high);
        } else if (cameras.last.lensDirection == CameraLensDirection.back) {
          cameraController =
              CameraController(cameras.last, ResolutionPreset.high);
        } else {
          cameraController =
              CameraController(cameras.first, ResolutionPreset.high);
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

    return Transform.scale(
        scale: (1 /
            (cameraController!.value.aspectRatio *
                MediaQuery.of(context).size.aspectRatio)),
        alignment: Alignment.topCenter,
        child: CameraPreview(cameraController!));
  }

  @override
  Widget build(BuildContext context) {
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
          const CreditCircle(value: 3),
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
                          // User picks an image from gallery
                          // Open the results screen by passing the chosen image
                          ImagePicker picker = ImagePicker();
                          XFile? file = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (file != null) {
                            await Future.delayed(const Duration(seconds: 1));

                            if (context.mounted) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScannerResultScreen(
                                          picture: file,
                                          scannerType: widget.scannerType)));
                            }
                          }
                          // Else, do nothing
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          // Image is captured
                          // Open the results screen shortly after and pass the captured image to it
                          XFile picture = await cameraController!.takePicture();

                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScannerResultScreen(
                                          picture: picture,
                                          scannerType: widget.scannerType,
                                        )));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary),
                        child: const Text(
                          "Take Picture",
                          style: TextStyle(color: Colors.white),
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
