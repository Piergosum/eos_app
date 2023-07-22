import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    required this.inputFormatters,
    required this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final Function(String) validator;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: (value) {
        return validator(value!);
      },
      controller: controller,
      autofocus: false,
      cursorHeight: 20,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
