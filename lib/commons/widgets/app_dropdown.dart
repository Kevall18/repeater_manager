import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.labelText,
    this.hintText,
    this.itemLabelBuilder,
    this.validator,
  });

  final List<T> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? labelText;
  final String? hintText;
  final String Function(T item)? itemLabelBuilder;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
      ),
      items: items
          .map(
            (item) => DropdownMenuItem<T>(
              value: item,
              child: Text(itemLabelBuilder?.call(item) ?? item.toString()),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
