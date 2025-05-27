import 'package:flutter/material.dart';

class AIMessageFormat extends StatelessWidget {
  const AIMessageFormat({super.key, required this.message, required this.textSize});

  final String message;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    // This is a goofy format string
    final RegExp regex = RegExp(r'\*\*(.*?)\*\*');
    final List<TextSpan> textSpans = [];
    int currentIndex = 0;

    message.replaceAllMapped(regex, (Match match) {
      final boldText = match.group(1)!;
      final startIndex = match.start;
      final endIndex = match.end;

      // MARK: This is where the selectors are formatted
      textSpans
          .add(TextSpan(text: message.substring(currentIndex, startIndex)));
      textSpans.add(TextSpan(
        text: boldText,
        style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.scrim),
      ));

      currentIndex = endIndex;
      return '';
    });

    // Recreate the text into one format
    textSpans.add(TextSpan(text: message.substring(currentIndex)));

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Theme.of(context).colorScheme.scrim, fontSize: textSize,),
        children: textSpans,
      ),
    );
  }
}
