import 'package:flutter/material.dart';

class NoSavedResults extends StatelessWidget {
  const NoSavedResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
                  Icons.save,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  "It looks like there are no saved results.\nSave an ID or HA after results have been received.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                )
          ],
        ),
      ),
    );
  }
}
