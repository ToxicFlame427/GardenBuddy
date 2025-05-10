// USING PERMISSION HANDLING - DOES NOT WORK FOR IOS DEVICES
// AHHHHHhH THIS WOULD HAVE BEEN SO AWESOME!
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:garden_buddy/screens/results_screen.dart';
import 'package:garden_buddy/widgets/objects/credit_circle.dart';
import 'package:garden_buddy/widgets/dialogs/custom_info_dialog.dart';
import 'package:garden_buddy/widgets/objects/picture_quality_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool cameraGranted = false;
  bool isLoading = false;

  @override
  void initState() {
    // Initialize the camer upon loading
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Ensure widget is still mounted when callback executes
        _setupCameraController();
      }
    });
  }

  @override
  void dispose() {
    // As long as the cmaer controller is not null, dispose of the camera after the state ends
    if (cameraController != null) {
      cameraController!.dispose();
    }
    super.dispose();
  }

  // Ensure you have these imports:
// import 'package:camera/camera.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';

  Future<void> _setupCameraController() async {
    // Initial isLoading set should be conditional on mounted to avoid errors if called late
    if (mounted && !isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    // Check initial status (optional but good for debugging)
    // PermissionStatus initialStatus = await Permission.camera.status;
    // debugPrint("iOS Camera Permission Status BEFORE request: $initialStatus");

    // Request camera permission
    PermissionStatus cameraPermissionStatus = await Permission.camera.request();
    debugPrint(
        "iOS Camera Permission Status AFTER request: $cameraPermissionStatus");

    // If you also strictly need microphone for the camera preview to work (usually not if enableAudio: false)
    // PermissionStatus microphonePermissionStatus = await Permission.microphone.request();
    // debugPrint("iOS Microphone Permission Status: $microphonePermissionStatus");

    // Determine if all necessary permissions are granted
    // For now, let's assume only camera is critical for the preview logic you have.
    // If enableAudio: true, you'd add: && microphonePermissionStatus.isGranted
    bool permissionsGranted = cameraPermissionStatus.isGranted;

    List<CameraDescription> localCameras = [];
    if (permissionsGranted) {
      // Only try to get cameras if permission is granted
      localCameras = await availableCameras();
    }

    // Now, update the state based on permissions and camera availability
    if (mounted) {
      setState(() {
        cameraGranted = permissionsGranted; // Update cameraGranted state
        cameras = localCameras; // Update cameras list state

        if (cameraGranted && localCameras.isNotEmpty) {
          CameraDescription selectedCamera = localCameras.firstWhere(
            (cam) => cam.lensDirection == CameraLensDirection.back,
            orElse: () => localCameras
                .first, // Fallback to the first camera if no back camera
          );

          cameraController = CameraController(
            selectedCamera,
            ResolutionPreset.high,
            enableAudio:
                false, // Explicitly false, so microphone isn't strictly needed by controller
          );

          // Initialize the controller and update loading state
          cameraController!.initialize().then((_) {
            if (mounted) {
              cameraController!.setFlashMode(FlashMode.off).catchError((e) {
                debugPrint("Error setting flash mode: $e");
                // Non-fatal, continue
              });
              setState(() {
                isLoading = false; // Initialization successful
              });
            }
          }).catchError((e) {
            debugPrint("Error initializing camera controller: $e");
            if (mounted) {
              setState(() {
                cameraController = null; // Failed to initialize
                isLoading = false;
              });
            }
          });
        } else {
          // This block handles:
          // 1. Permissions not granted
          // 2. Permissions granted, but no cameras available
          if (!cameraGranted) {
            debugPrint(
                "Camera permission was NOT granted after request. Status: $cameraPermissionStatus");
          }
          if (localCameras.isEmpty && cameraGranted) {
            debugPrint("Permissions granted, but no cameras were found.");
          }
          cameraController =
              null; // Ensure controller is null if we can't proceed
          isLoading = false; // We're done trying to load
        }
      });
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Camera Permission"),
        content: const Text(
            "Camera permission is required to use this feature. Please enable it in app settings."),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              openAppSettings(); // From permission_handler
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
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
    debugPrint(
        "State: cameraGranted: $cameraGranted, isLoading: $isLoading, controller: ${cameraController != null}, initialized: ${cameraController?.value.isInitialized}");

    // Handle Loading State
    if (isLoading) {
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
              "Camera Loading...",
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

    // Handle Permission Denied State
    if (!cameraGranted) {
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
              "Camera permission was not granted.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade400,
                  fontSize: 20),
            ),
            ElevatedButton(
                onPressed: () {
                  _showPermissionDeniedDialog();
                },
                child: const Text("Grant Access"))
          ],
        ),
      );
    }

    // 3. Handle No Camera Controller or Not Initialized (after loading and permission checks)
    // This also implicitly covers the case where no cameras were found.
    if (cameraController == null || !cameraController!.value.isInitialized) {
      // It's possible that `isLoading` became false, but the controller is still null
      // (e.g., no cameras found, or permission was granted AFTER initial check but before re-init)
      // or failed to initialize for some reason.
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
              "No camera available or failed to initialize.",
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