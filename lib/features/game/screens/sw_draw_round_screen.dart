import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import 'package:sketch_wizards/features/game/widgets/timer_widget.dart';
import 'package:sketch_wizards/features/game/widgets/wizard_widget.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWDrawRoundScreen extends StatefulWidget {
  const SWDrawRoundScreen({super.key});

  @override
  State<SWDrawRoundScreen> createState() => _SWDrawRoundScreenState();
}

class _SWDrawRoundScreenState extends State<SWDrawRoundScreen> {
  final Duration initialDelay = const Duration(milliseconds: 300);

  final gameServiceProvider = GetIt.I<SWGameServiceProvider>();

  late final userRound = gameServiceProvider.currentUserRound;

  late final timer = SWGameTimerController(gameServiceProvider.roundDuration,
      onFinished: () => goToNewScreen(false));

  bool isGoingToNewScreen = false;

  void goToNewScreen(bool isCorrect) {
    if (isGoingToNewScreen) {
      return;
    }

    isGoingToNewScreen = true;

    int score = timer.value.inSeconds;

    // if the user guessed the word in the last second give him 1 point
    if (isCorrect && score < 1) {
      score = 1;
    }

    gameServiceProvider.setCurrentUserRound(
        isCorrect ? SWUserRoundStatus.guessed : SWUserRoundStatus.failed,
        score: isCorrect ? score : null);

    Navigator.of(context).pushNamedAndRemoveUntil(
      SketchWizardsRoutes.drawResult.route,
      (route) => false,
      arguments: {
        'isCorrect': isCorrect,
        'onScreenClose': (BuildContext context) {
          if (!context.mounted) return;
          if (gameServiceProvider.isCurrentRoundFinished) {
            bool isLastRound = gameServiceProvider.currentRoundNumber ==
                gameServiceProvider.game.rounds.length - 1;
            // end game if the last round
            Navigator.of(context).pushNamedAndRemoveUntil(
                isLastRound
                    ? SketchWizardsRoutes.finalChart.route
                    : SketchWizardsRoutes.roundChart.route,
                (route) => false);
          } else {
            gameServiceProvider.nextPlayer();

            Navigator.of(context).pushNamedAndRemoveUntil(
                SketchWizardsRoutes.roundIntro.route, (route) => false);
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

  bool isGuessStarted = false;

  late Stream<String?> possibleWord =
      Stream.periodic(thinkingTimer, (_) => getPossibleWord());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(initialDelay);
      setState(() {
        isGuessStarted = true;
      });
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
                      StreamBuilder(
                          stream: possibleWord,
                          builder: (context, snapshot) {
                            return Column(
                              children: [
                                Container(
                                  width: 350,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: SWTheme.primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        snapshot.data ?? "Thinking...",
                                        style: SWTheme.boldTextStyle.copyWith(
                                          fontSize: 40,
                                          color: SWTheme.textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ).animate(
                                  onPlay: (controller) => controller.repeat(),
                                  effects: [
                                    ShakeEffect(
                                      rotation: 0.05,
                                      delay: 2.seconds,
                                    ),
                                  ],
                                ),
                                const WizardWidget(isGuessed: null).animate(
                                  onPlay: (controller) => controller.repeat(),
                                  effects: [
                                    ShakeEffect(
                                      rotation: 0.1,
                                      delay: 1.7.seconds,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                      const SizedBox(height: 30),
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
                      //TODO link with the game timer
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: (isGuessStarted)
                            ? TimerWidget(
                                duration:
                                    gameServiceProvider.roundDuration.inSeconds,
                              )
                            : const SizedBox.shrink(),
                      ),
                      const Spacer(),
                      SWTextButton(
                        text: "Skip",
                        onPressed: () => goToNewScreen(false),
                      ),
                      const SizedBox(height: 30),
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
