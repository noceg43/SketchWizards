import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/start_game/screens/sw_home.dart';

enum SketchWizardsRoutes {
  home,
}

extension SketchWizardsRoutesExtension on SketchWizardsRoutes {
  String get route {
    switch (this) {
      case SketchWizardsRoutes.home:
        return '/';
    }
  }
}

class SketchWizardsRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (SketchWizardsRoutes.home.route == settings.name) {
      return MaterialPageRoute(builder: (_) => const SWHome());
    } else {
      return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
