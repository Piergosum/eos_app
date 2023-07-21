import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {super.key,
      required this.type,
      required this.value,
      required this.onChanged});

  final String type;
  final bool value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(type),
        Checkbox(
          value: value,
          onChanged: onChanged(value, type),
        ),
      ],
    );
  }
}
