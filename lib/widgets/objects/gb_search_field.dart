import 'package:flutter/material.dart';

class GbSearchField extends StatelessWidget {
  const GbSearchField(
      {super.key,
      required this.hint,
      required this.controller,
      required this.onSearch,
      required this.onFilter});

  final TextEditingController controller;
  final String hint;
  final void Function() onSearch;
  final void Function() onFilter;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 2.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        label: Text(hint),
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle:
            TextStyle(color: Theme.of(context).colorScheme.primary),
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onFilter,
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(Icons.filter_list),
              style: ButtonStyle(),
            ),
            IconButton(
              onPressed: onSearch,
              color: Theme.of(context).colorScheme.primary,
              icon: Icon(Icons.search),
            ),
          ],
        ),
      ),
    );
  }
}
