import 'package:flutter/material.dart';

class GbIconTextfield extends StatelessWidget {
  const GbIconTextfield(
      {super.key,
      required this.hint,
      required this.controller,
      required this.icon,
      required this.onPressed});

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
        suffixIcon: IconButton(
          onPressed: onPressed,
          color: Theme.of(context).colorScheme.primary,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
