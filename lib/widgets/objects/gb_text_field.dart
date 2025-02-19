import 'package:flutter/material.dart';

class GbTextfield extends StatelessWidget {
  const GbTextfield(
      {super.key,
      required this.hint,
      required this.controller,
      required this.multiline});

  final TextEditingController controller;
  final String hint;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      expands: multiline,
      keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
      maxLines: multiline ? null : 1,
      minLines: null,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        label: Text(hint),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
