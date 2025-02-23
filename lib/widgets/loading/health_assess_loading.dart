import 'package:flutter/material.dart';
import 'package:garden_buddy/widgets/formatting/horizontal_rule.dart';
import 'package:shimmer/shimmer.dart';

class HealthAssessLoading extends StatelessWidget {
  const HealthAssessLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).cardColor,
          highlightColor: Color.fromARGB(255, 150, 150, 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20,
                color: Theme.of(context).cardColor,
              ),
              HorizontalRule(color: Theme.of(context).cardColor, height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 150,
                        height: 15,
                        color: Theme.of(context).cardColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 125,
                        height: 30,
                        color: Theme.of(context).cardColor,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 150,
                        height: 15,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: Container(
                      width: 60,
                      height: 60,
                      color: Theme.of(context).cardColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: 150,
                height: 25,
                color: Theme.of(context).cardColor,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: double.infinity,
                          height: 10,
                          color: Theme.of(context).cardColor,
                        ),
                      ],
                    );
                  }
                ),
            ],
          ),
        ),
      ),
    );
  }
}
