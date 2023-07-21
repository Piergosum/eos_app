import 'package:eos_app/eos_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home/controller/home_screen_controller.dart';
import 'storage/shared_preferences_class.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesClass.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeScreenController>(
          create: (_) => HomeScreenController(),
        ),
      ],
      child: const EosApp(),
    ),
  );
}
