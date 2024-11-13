import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 100,
            ),
            Text(
              "No Connection found, please ensure you have an internet connection",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18
              ),
            )
          ],
        ),
    );
  }
}
