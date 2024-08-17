import 'package:flutter/material.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';
import 'package:sketch_wizards/features/draw/logic/canvas_controller.dart';
import 'package:sketch_wizards/sw_router.dart';

class SketchWizardsApp extends StatefulWidget {
  const SketchWizardsApp({super.key});

  @override
  State<SketchWizardsApp> createState() => _SketchWizardsAppState();
}

class _SketchWizardsAppState extends State<SketchWizardsApp> {
  GlobalKey canvasKey = GlobalKey();

  late CanvasController controller = CanvasController(canvasKey: canvasKey);

  Duration interval = const Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: SWTheme.themeData,
      onGenerateRoute: SketchWizardsRouter.onGenerateRoute,
    );
  }
}
