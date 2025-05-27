import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';

// This widget is made to detects screen size and rebuild the UI based on that
// Many things can start the way they are, however some things like lists need to change
class Responsive extends StatelessWidget {
  const Responsive(
      {this.smallPhone,
      required this.phone,
      this.tablet,
      this.largeTablet,
      super.key});

  final Widget? smallPhone;
  final Widget phone;
  final Widget? tablet;
  final Widget? largeTablet;

  // Functions madefor conditional statments
  static bool isSmallPhone(BuildContext context) {
    if (MediaQuery.sizeOf(context).width < smallPhoneWidthT) {
      return true;
    }

    return false;
  }

  static bool isPhone(BuildContext context) {
    if (MediaQuery.sizeOf(context).width > smallPhoneWidthT &&
        MediaQuery.sizeOf(context).width < phoneWidthT) {
      return true;
    }

    return false;
  }

  static bool isTablet(BuildContext context) {
    // Large tablets are tablets too, so make that check here
    if ((MediaQuery.sizeOf(context).width > phoneWidthT &&
            MediaQuery.sizeOf(context).width < tabletWidthT) ||
        isLargeTablet(context)) {
      return true;
    }

    return false;
  }

  static bool isLargeTablet(BuildContext context) {
    if (MediaQuery.sizeOf(context).width > tabletWidthT) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (isSmallPhone(context)) {
      // If small phone widget does not exist, return regular
      if (smallPhone != null) {
        return smallPhone!;
      }

      return phone;
    } else if (isPhone(context)) {
      return phone;
    } else if (isTablet(context)) {
      // If tablet widget does not exist, return regular
      if (tablet != null) {
        return tablet!;
      }

      return phone;
    } else {
      if (largeTablet != null) {
        return largeTablet!;
      } else {
        // If large tablet does not exist, check if there is a tablet default: if not, then return regular
        if (tablet != null) {
          return tablet!;
        }

        return phone;
      }
    }
  }
}
