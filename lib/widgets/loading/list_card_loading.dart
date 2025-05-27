import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';
import 'package:shimmer/shimmer.dart';

class ListCardLoading extends StatelessWidget {
  const ListCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    // Default sizes
    double imageSize = 90;

    // Conditional sizes
    if (Responsive.isSmallPhone(context)) {
      imageSize = 75;
    } else if (Responsive.isLargeTablet(context)) {
      imageSize = 110;
    }

    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Shimmer.fromColors(
            baseColor: Color.fromARGB(255, 150, 150, 150),
            highlightColor: Theme.of(context).cardColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 30,
                          width: 175,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 15,
                          width: 125,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
