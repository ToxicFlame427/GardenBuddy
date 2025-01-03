
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScannerResultScreen extends StatefulWidget {
  const ScannerResultScreen(
      {super.key, required this.picture, required this.scannerType});

  final String scannerType;
  final XFile picture;

  @override
  State<ScannerResultScreen> createState() {
    return _ScannerResultState();
  }
}

class _ScannerResultState extends State<ScannerResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.scannerType} Results",
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData().copyWith(color: Colors.white),
      ),
    );
    // For displaying the image: Image.file(File(widget.picture.path));
  }
}
