import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/start_game/screens/sw_game_options.dart';
import 'package:sketch_wizards/features/start_game/screens/sw_home.dart';

enum SketchWizardsRoutes {
  home,
  gameOptions,
}

extension SketchWizardsRoutesExtension on SketchWizardsRoutes {
  String get route {
    switch (this) {
      case SketchWizardsRoutes.home:
        return '/';
      case SketchWizardsRoutes.gameOptions:
        return '/gameOptions';
    }
  }
}

class SketchWizardsRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (SketchWizardsRoutes.home.route == settings.name) {
      return MaterialPageRoute(builder: (_) => const SWHome());
    }
    if (SketchWizardsRoutes.gameOptions.route == settings.name) {
      return MaterialPageRoute(builder: (_) => const SWGameOptions());
    } else {
      return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }
}
