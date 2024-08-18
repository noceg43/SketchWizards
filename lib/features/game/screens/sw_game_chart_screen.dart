import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

//TODO add ui
class SWGameChartScreen extends StatelessWidget {
  const SWGameChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameServiceProvider = GetIt.I<SWGameServiceProvider>();

    return SWScaffold(
      title: 'Congratulations!',
      action: Center(
        child: SWTextButton(
          text: "Play Again",
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              SketchWizardsRoutes.home.route, (route) => false),
        ),
      ),
      children: [
        for (final MapEntry<SWPlayer, int> entry
            in gameServiceProvider.playersScores.entries)
          Text(
            '#${gameServiceProvider.playersScores.keys.toList().indexOf(entry.key) + 1} ${entry.key.name}: ${entry.value}',
            style: SWTheme.regularTextStyle,
          )
      ],
    );
  }
}
