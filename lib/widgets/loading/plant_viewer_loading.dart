import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PlantViewerLoading extends StatelessWidget {
  const PlantViewerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
            baseColor: Theme.of(context).cardColor,
            highlightColor: Color.fromARGB(255, 150, 150, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  child: Container(
                    width: double.infinity,
                    height: 170,
                    color: Theme.of(context).cardColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 40,
                        color: Theme.of(context).cardColor,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: 225,
                        height: 25,
                        color: Theme.of(context).cardColor,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 20,
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
                          }),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: 225,
                        height: 25,
                        color: Theme.of(context).cardColor,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: 225,
                        height: 25,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }
}
