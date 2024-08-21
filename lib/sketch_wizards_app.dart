import 'package:flutter/material.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';
import 'package:sketch_wizards/sw_router.dart';

class SketchWizardsApp extends StatefulWidget {
  const SketchWizardsApp({super.key});

  @override
  State<SketchWizardsApp> createState() => _SketchWizardsAppState();
}

class _SketchWizardsAppState extends State<SketchWizardsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SketchWizardsRoutes.splashLoading.route,
      debugShowCheckedModeBanner: false,
      theme: SWTheme.themeData,
      onGenerateRoute: SketchWizardsRouter.onGenerateRoute,
    );
  }
}
