import 'package:eos_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class EosApp extends StatelessWidget {
  const EosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(0, 181, 88, 1)),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
