import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';

// This widget is made to detects screen size and rebuild the UI based on that
// Mnay things can start the way they are, however some things like lists need to change
class Responsive extends StatelessWidget {
  const Responsive(
      {this.smallPhone, required this.phone, this.tablet, super.key});

  final Widget? smallPhone;
  final Widget phone;
  final Widget? tablet;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth < smallPhoneWidthT) {
      // If small phone widget does not exist, return regular
      if (smallPhone != null) {
        return smallPhone!;
      } else {
        return phone;
      }
    } else if (screenWidth < phoneWidthT) {
      return phone;
    } else {
      // If tablet widget does not exist, return regular
      if (tablet != null) {
        return tablet!;
      } else {
        return phone;
      }
    }
  }
}
