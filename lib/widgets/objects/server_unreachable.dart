import 'package:flutter/material.dart';

class ServerUnreachable extends StatelessWidget{
  const ServerUnreachable({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/icons/server_icon.png",
          width: 125,
          height: 125,
          fit: BoxFit.fill,
        ),
        Text(
          "The server cannot be reached\nPlease try again later.",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}