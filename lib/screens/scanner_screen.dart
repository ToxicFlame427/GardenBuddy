import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key, required this.scannerType});

  final String scannerType;

  @override
  State<StatefulWidget> createState() {
    return _ScannerScreenState();
  }
}

class _ScannerScreenState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scannerType),
        backgroundColor: Colors.green,
        centerTitle: false,
      ),
      body: const Text("This is the camera scanner screen"),
    );
  }
}
