import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:garden_buddy/screens/results_screen.dart';

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

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        // _cameras.first = Front camera, _camera.last = Back camera
        cameraController =
            CameraController(_cameras.last, ResolutionPreset.high);
      });

      cameraController?.initialize().then((_) {
        setState(() {});
      });
    }
  }

  Widget _conditionalCamera() {
    // Return the camera view if the controller is initialized correctly
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return CameraPreview(cameraController!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.scannerType,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: false,
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
      body: Stack(
        children: [
          _conditionalCamera(),
          SafeArea(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Best practices card
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Rules go here bub"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          // TODO: Allow user to pick an image from gallery
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        onPressed: () async {
                          // Image is captured
                          // Open the results screen shortly after and pass the captured image to it
                          XFile picture = await cameraController!.takePicture();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ScannerResultScreen(picture: picture, scannerType: widget.scannerType,)));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        child: const Text(
                          "Take Picture",
                          style: TextStyle(color: Colors.white),
                        )
                    )
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
