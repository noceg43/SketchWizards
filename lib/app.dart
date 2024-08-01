import 'package:flutter/material.dart';

class SketchWizardsApp extends StatefulWidget {
  const SketchWizardsApp({super.key});

  @override
  State<SketchWizardsApp> createState() => _SketchWizardsAppState();
}

class _SketchWizardsAppState extends State<SketchWizardsApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Placeholder(),
      ),
    );
  }
}
