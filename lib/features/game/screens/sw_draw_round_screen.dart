import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:ml_dart_wizard/models/guess_result.dart';
import 'package:sketch_wizards/common/widgets/player_widget.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/draw/constants.dart';
import 'package:sketch_wizards/features/draw/widgets/widget_canvas.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_timer.dart';
import 'package:sketch_wizards/features/game/logic/sw_wizard_guess_provider.dart';
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
            bool isLastRound = gameServiceProvider.currentRoundNumber ==
                gameServiceProvider.game.rounds.length - 1;
            // end game if the last round
            if (isLastRound) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  SketchWizardsRoutes.finalChart.route, (route) => false);
            } else {
              Navigator.of(context)
                  .pushNamed(SketchWizardsRoutes.roundChart.route);
            }
          } else {
            gameServiceProvider.nextPlayer();

            Navigator.of(context).popUntil((route) =>
                SketchWizardsRoutes.roundIntro.route == route.settings.name);
          }
        },
      },
    );
  }

  GlobalKey canvasKey = GlobalKey();

  late final wizardGuessProvider = SWWizardGuessProvider(
    canvasKey: canvasKey,
    onGuessed: () => goToNewScreen(true),
  );

  String? getPossibleWord() {
    if (wizardGuessProvider.guessResult.value is GuessResult) {
      return (wizardGuessProvider.guessResult.value as GuessResult).topGuess();
    }
    return null;
  }

  late Stream<String?> possibleWord =
      Stream.periodic(thinkingTimer, (_) => getPossibleWord());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 1));
      gameServiceProvider.setCurrentUserRound(SWUserRoundStatus.inProgress);
      timer.start();
      wizardGuessProvider.startGuessing(userRound.word);
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
                  child: Column(
                    children: [
                      PlayerWidget(
                          text: gameServiceProvider.currentPlayer.name),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: wizardGuessProvider.guessResult,
                        builder: (context, child) => Text(
                          wizardGuessProvider.guessResult.value.toString(),
                          style: SWTheme.regularTextStyle,
                        ),
                      ),
                      const Spacer(),
                      StreamBuilder(
                          stream: possibleWord,
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? "Thinking...",
                              style: SWTheme.boldTextStyle.copyWith(
                                fontSize: 20,
                                color: SWTheme.textColor,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: // Drawing canvas
                          WidgetCanvas(
                        canvasKey: canvasKey,
                      ),
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
                            "-${timer.value.inSeconds}",
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
