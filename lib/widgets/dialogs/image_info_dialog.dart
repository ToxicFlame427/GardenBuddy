import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// ignore: library_prefixes
import 'package:garden_buddy/models/api/garden_api/plant_species_details.dart' as PlantSpeciesClass;
import 'package:garden_buddy/widgets/objects/hyperlink.dart';
import 'package:shimmer/shimmer.dart';

class ImageInfoDialog extends StatelessWidget {
  const ImageInfoDialog({super.key, required this.imageData});

  final PlantSpeciesClass.Image imageData;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Image Info",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                  color: Theme.of(context).colorScheme.primary,
                )
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageData.url,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      color: Colors.grey,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Text("Error retreiving image");
                },
              ),
            ),
            SizedBox(height: 12,),
            // MARK: This might need to change as not all credit will be in HTML, same goes for the image license as it may not always be a link
            Html(data: imageData.credit),
            Text("License", style: TextStyle(fontWeight: FontWeight.bold)),
            Hyperlink(label: "Image License", urlString: imageData.imageLicense,),
            Hyperlink(label: "Original Image URL", urlString: imageData.originalUrl)
          ],
        ),
      ),
    );
  }
}
