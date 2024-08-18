import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/common/widgets/player_widget.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_timer.dart';
import 'package:sketch_wizards/features/game/models/sw_user_round.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWDrawRoundScreen extends StatefulWidget {
  const SWDrawRoundScreen({super.key});

  @override
  State<SWDrawRoundScreen> createState() => _SWDrawRoundScreenState();
}

class _SWDrawRoundScreenState extends State<SWDrawRoundScreen> {
  final gameServiceProvider = GetIt.I<SWGameServiceProvider>();

  late final userRound = gameServiceProvider.currentUserRound;

  late final timer = SWGameTimerController(gameServiceProvider.roundDuration,
      onFinished: () => goToNewScreen(false));

  void goToNewScreen(bool isCorrect) {
    int score = timer.value.inSeconds;

    gameServiceProvider.setCurrentUserRound(
        isCorrect ? SWUserRoundStatus.guessed : SWUserRoundStatus.failed,
        score: isCorrect ? score : null);

    Navigator.of(context).pushReplacementNamed(
      SketchWizardsRoutes.drawResult.route,
      arguments: {
        'isCorrect': isCorrect,
        'onScreenClose': (BuildContext context) {
          if (gameServiceProvider.isCurrentRoundFinished) {
            Navigator.of(context)
                .pushNamed(SketchWizardsRoutes.roundChart.route);
          } else {
            gameServiceProvider.nextPlayer();

            Navigator.of(context).popUntil((route) =>
                SketchWizardsRoutes.roundIntro.route == route.settings.name);
          }
        },
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameServiceProvider.setCurrentUserRound(SWUserRoundStatus.inProgress);
      timer.start();
    });
  }

  @override
  void dispose() {
    timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SWScaffold(
        scrollable: false,
        title: userRound.word,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: PlayerWidget(
                        text: gameServiceProvider.currentPlayer.name),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Placeholder(
                          color: SWTheme.textColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SWTextButton(
                                  text: "Guessed",
                                  onPressed: () => goToNewScreen(true)),
                              const SizedBox(height: 20),
                              SWTextButton(
                                  text: "Failed",
                                  onPressed: () => goToNewScreen(false)),
                            ],
                          )),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      ListenableBuilder(
                        listenable: timer,
                        builder: (context, _) {
                          return Text(
                            timer.value.toString(),
                            style: SWTheme.boldTextStyle.copyWith(
                              fontSize: 50,
                              color: SWTheme.textColor,
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      SWTextButton(
                        text: "Skip",
                        onPressed: () => goToNewScreen(false),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
