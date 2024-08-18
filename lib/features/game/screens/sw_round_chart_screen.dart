import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

// TODO add ui
class SWRoundChartScreen extends StatelessWidget {
  const SWRoundChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameServiceProvider = GetIt.I<SWGameServiceProvider>();

    SWPlayer mvpPlayer = gameServiceProvider.currentMVPplayer;

    int mvpScore = gameServiceProvider.currentRound.userRounds
        .firstWhere(
          (userRound) => userRound.userId == mvpPlayer.id,
        )
        .score;

    bool isLastRound = gameServiceProvider.currentRoundNumber ==
        gameServiceProvider.game.rounds.length - 1;

    return SWScaffold(
      title: 'End Round #${gameServiceProvider.currentRoundNumber}',
      bottomWidget: Center(
        child: SWTextButton(
          onPressed: () {
            // end game if the last round
            if (isLastRound) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  SketchWizardsRoutes.finalChart.route, (route) => false);
            } else {
              gameServiceProvider.nextPlayer();
              Navigator.of(context)
                  .pushNamed(SketchWizardsRoutes.roundIntro.route);
            }
          },
          text: isLastRound ? 'End Game' : 'Next Round',
        ),
      ),
      children: [
        Text(
          'MVP: ${mvpPlayer.name}, score: $mvpScore ',
          style: SWTheme.regularTextStyle,
        ),
        const SizedBox(height: 20),
        Text(
          'Players scores:',
          style: SWTheme.regularTextStyle,
        ),
        ...[
          for (final MapEntry<SWPlayer, int> entry
              in gameServiceProvider.playersScores.entries)
            Text(
              '#${gameServiceProvider.playersScores.keys.toList().indexOf(entry.key) + 1} ${entry.key.name}: ${entry.value}',
              style: SWTheme.regularTextStyle,
            )
        ]
      ],
    );
  }
}
