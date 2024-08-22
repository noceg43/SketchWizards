import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/common/widgets/player_widget.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/game/widgets/leadboard_player.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

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

    return SWScaffold(
      showFloatingActionButton: true,
      title: 'End Round #${(gameServiceProvider.currentRoundNumber ?? 0) + 1}',
      bottomWidget: Center(
        child: SWTextButton(
          onPressed: () {
            gameServiceProvider.nextPlayer();
            Navigator.of(context).pushNamedAndRemoveUntil(
                SketchWizardsRoutes.roundIntro.route, (route) => false);
          },
          text: 'Next Round',
        ),
      ),
      children: [
        const SizedBox(height: 60),
        Stack(
          clipBehavior: Clip.none,
          children: [
            PlayerWidget(text: mvpPlayer.name),
            Positioned(
              left: -60,
              top: -30,
              child: Transform.rotate(
                angle: -0.4, // Adjust the angle as needed (in radians)
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'MVP!',
                    style: SWTheme.boldTextStyle.copyWith(
                      color: SWTheme.primaryColor,
                      fontSize: 50,
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(2, 2),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // score widget
            Positioned(
              right: -20,
              top: -30,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: SWTheme.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+${mvpScore}pt',
                  style: SWTheme.regularTextStyle.copyWith(
                    color: SWTheme.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        Text(
          'Leadboard:',
          style: SWTheme.regularTextStyle,
        ),
        const SizedBox(height: 20),
        IntrinsicWidth(
          child: Column(
            children: [
              for (final MapEntry<SWPlayer, int> entry
                  in gameServiceProvider.playersScores.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: LeadboardPlayer(
                    index: gameServiceProvider.playersScores.keys
                        .toList()
                        .indexOf(entry.key),
                    player: entry.key,
                    score: entry.value,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
