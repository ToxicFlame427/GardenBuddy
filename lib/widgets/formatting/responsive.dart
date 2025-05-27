import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';

// This widget is made to detects screen size and rebuild the UI based on that
// Mnay things can start the way they are, however some things like lists need to change
class Responsive extends StatelessWidget {
  const Responsive(
      {required this.smallPhone,
      required this.phone,
      required this.tablet,
      super.key});

  final Widget smallPhone;
  final Widget phone;
  final Widget tablet;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    if (screenWidth < smallPhoneWidthT) {
      return smallPhone;
    } else if (screenWidth < phoneWidthT) {
      return phone;
    } else {
      return tablet;
    }
  }
}
