import 'package:flutter/material.dart';

TextFormField myTextFormField(
    {required labelText,
    required TextEditingController controller,
    required bool isDarkMode,
    required BuildContext context,
    int? maxLengthEnforcement,
    TextInputType? keyboardType}) {
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLengthEnforcement ?? 1,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color:
              isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isDarkMode
              ? Colors.blue
              : Theme.of(context).colorScheme.secondary,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: isDarkMode ? Colors.yellow : Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      labelText: labelText,
      labelStyle: TextStyle(
        color:
            isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary,
      ),
      errorStyle: TextStyle(
        color: isDarkMode ? Colors.grey : Colors.red,
      ),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return '$labelText cannot be empty';
      }
      return null;
    },
  );
}
