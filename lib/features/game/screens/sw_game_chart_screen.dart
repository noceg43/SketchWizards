import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/game/widgets/leadboard_player.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';
import 'package:sketch_wizards/sw_router.dart';

class SWGameChartScreen extends StatelessWidget {
  const SWGameChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameServiceProvider = GetIt.I<SWGameServiceProvider>();

    Map<SWPlayer, int> playersScores = gameServiceProvider.playersScores;

    MapEntry<SWPlayer, int> winner = playersScores.entries.first;

    playersScores.remove(winner.key);

    return SWScaffold(
      showFloatingActionButton: true,
      title: 'Congratulations!',
      action: Center(
        child: SWTextButton(
          text: "Play Again",
          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              SketchWizardsRoutes.home.route, (route) => false),
        ),
      ),
      children: [
        const SizedBox(height: 40),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 5,
              child: LeadboardPlayer(
                  index: 0,
                  player: winner.key,
                  score: winner.value,
                  isWinner: true),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 30),
        IntrinsicWidth(
          child: Column(
            children: [
              for (final MapEntry<SWPlayer, int> entry in playersScores.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: LeadboardPlayer(
                    index: gameServiceProvider.playersScores.keys
                        .toList()
                        .indexOf(entry.key),
                    player: entry.key,
                    score: entry.value,
                    isWinner: gameServiceProvider.playersScores.keys
                            .toList()
                            .indexOf(entry.key) ==
                        0,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
