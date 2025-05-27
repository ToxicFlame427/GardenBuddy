import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/formatting/responsive.dart';

class PictureQualityCard extends StatelessWidget {
  const PictureQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    double imageSize = 65;
    double textSize = 14;

    if (Responsive.isSmallPhone(context)) {
      imageSize = 55;
    } else if (Responsive.isTablet(context)) {
      imageSize = 85;
      textSize = 18;
    }

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Picture quality can affect results!",
                      style: TextStyle(
                        fontSize: textSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/icons/identify_example_good.jpg",
                            width: imageSize,
                            height: imageSize,
                          ),
                        ),
                        const Text(
                          "=",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Image.asset(
                          "assets/icons/check_mark.png",
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/icons/identify_example_bad.jpg",
                            width: imageSize,
                            height: imageSize,
                          ),
                        ),
                        const Text(
                          "=",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                        Image.asset(
                          "assets/icons/cross_mark.png",
                          width: 50,
                          height: 50,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
