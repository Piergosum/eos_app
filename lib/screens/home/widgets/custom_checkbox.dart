import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {super.key,
      required this.type,
      required this.onChanged,
      required this.valueListenable});

  final String type;
  final Function onChanged;
  final ValueListenable<bool> valueListenable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(type),
        ValueListenableBuilder(
          valueListenable: valueListenable,
          builder: (context, valueListenableValue, child) {
            return Checkbox(
              value: valueListenableValue,
              onChanged: (value) {
                onChanged(value, type);
              },
            );
          },
        ),
      ],
    );
  }
}
