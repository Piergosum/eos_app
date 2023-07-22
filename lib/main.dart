import 'package:eos_app/eos_app.dart';
import 'package:flutter/material.dart';
import 'storage/shared_preferences_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesClass.init();
  runApp(
    const EosApp(),
  );
}
