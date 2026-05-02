import 'package:flutter/material.dart';

void main() {
  runApp(const MacroFitApp());
}

class MacroFitApp extends StatelessWidget {
  const MacroFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MacroFit',
      home: Scaffold(body: SizedBox.shrink()),
    );
  }
}
