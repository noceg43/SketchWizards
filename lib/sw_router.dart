import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/game/screens/sw_draw_result_screen.dart';
import 'package:sketch_wizards/features/game/screens/sw_draw_round_screen.dart';
import 'package:sketch_wizards/features/game/screens/sw_game_chart_screen.dart';
import 'package:sketch_wizards/features/game/screens/sw_round_chart_screen.dart';
import 'package:sketch_wizards/features/game/screens/sw_round_intro_screen.dart';
import 'package:sketch_wizards/features/splash_loading/splash_loading_screen.dart';
import 'package:sketch_wizards/features/start_game/screens/sw_game_options.dart';
import 'package:sketch_wizards/features/start_game/screens/sw_home.dart';

enum SketchWizardsRoutes {
  splashLoading,
  home,
  gameOptions,
  roundIntro,
  drawRound,
  drawResult,
  roundChart,
  finalChart,
}

extension SketchWizardsRoutesExtension on SketchWizardsRoutes {
  String get route {
    switch (this) {
      case SketchWizardsRoutes.splashLoading:
        return '/Splash-loading';
      case SketchWizardsRoutes.home:
        return '/Home';
      case SketchWizardsRoutes.gameOptions:
        return '/Game-options';
      case SketchWizardsRoutes.roundIntro:
        return '/Round-intro';
      case SketchWizardsRoutes.drawRound:
        return '/Draw-round';
      case SketchWizardsRoutes.drawResult:
        return '/Draw-result';
      case SketchWizardsRoutes.roundChart:
        return '/Round-chart';
      case SketchWizardsRoutes.finalChart:
        return '/Final-chart';
    }
  }
}

class SketchWizardsRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    if (SketchWizardsRoutes.splashLoading.route == settings.name) {
      return MaterialPageRoute(
        settings: RouteSettings(name: SketchWizardsRoutes.splashLoading.route),
        builder: (_) => const SplashLoadingScreen(),
      );
    }
    if (SketchWizardsRoutes.home.route == settings.name) {
      return MaterialPageRoute(
        settings: RouteSettings(name: SketchWizardsRoutes.home.route),
        builder: (_) => const SWHome(),
      );
    }
    if (SketchWizardsRoutes.gameOptions.route == settings.name) {
      return MaterialPageRoute(
          settings: RouteSettings(name: SketchWizardsRoutes.gameOptions.route),
          builder: (_) => const SWGameOptions());
    }
    if (SketchWizardsRoutes.roundIntro.route == settings.name) {
      return MaterialPageRoute(
          settings: RouteSettings(name: SketchWizardsRoutes.roundIntro.route),
          builder: (_) => const SWRoundIntroScreen());
    }
    if (SketchWizardsRoutes.drawRound.route == settings.name) {
      return MaterialPageRoute(
        settings: RouteSettings(name: SketchWizardsRoutes.drawRound.route),
        builder: (_) => const SWDrawRoundScreen(),
      );
    }
    if (SketchWizardsRoutes.drawResult.route == settings.name) {
      Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;

      bool isCorrect = args['isCorrect'] as bool;
      Function(BuildContext context) onScreenClose =
          args['onScreenClose'] as Function(BuildContext context);

      return PageRouteBuilder(
        settings: RouteSettings(name: SketchWizardsRoutes.drawResult.route),
        pageBuilder: (context, animation, secondaryAnimation) =>
            SWDrawResultScreen(
          isCorrect: isCorrect,
          onScreenClose: onScreenClose,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, -1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      );
    }
    if (SketchWizardsRoutes.roundChart.route == settings.name) {
      return MaterialPageRoute(
        settings: RouteSettings(name: SketchWizardsRoutes.roundChart.route),
        builder: (_) => const SWRoundChartScreen(),
      );
    }
    if (SketchWizardsRoutes.finalChart.route == settings.name) {
      return MaterialPageRoute(
        settings: RouteSettings(name: SketchWizardsRoutes.finalChart.route),
        builder: (_) => const SWGameChartScreen(),
      );
    } else {
      return MaterialPageRoute(
          settings: settings, builder: (_) => const Scaffold());
    }
  }
}
