import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const DazzPrototypeApp());
}

class DazzPrototypeApp extends StatelessWidget {
  const DazzPrototypeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dazz Camera Prototype',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF0A25A),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
