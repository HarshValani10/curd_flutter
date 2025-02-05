import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Function(String)? onChanged; // Callback for text change
  final Function(String)? onValidation;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onValidation,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (onValidation != null) {
          onValidation!(value ?? ''); // Trigger custom validation
        }
        return validator?.call(value); // Use passed validator if any
      },
      onChanged: (text) {
        if (onChanged != null) {
          onChanged!(text); // Trigger custom onChanged callback
        }
      },
    );
  }
}
