import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/start_game/logic/sw_game_settings_provider.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWRoundIntroScreen extends StatelessWidget {
  const SWRoundIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameServiceProvider = GetIt.I<SWGameServiceProvider>();
    final gameSettingsProvider = GetIt.I<SWGameSettingsProvider>();

    return WillPopScope(
      onWillPop: () async => false,
      child: ListenableBuilder(
          listenable: gameServiceProvider,
          builder: (context, _) {
            return SWScaffold(
              action: Row(
                children: [
                  Text(
                    '${gameServiceProvider.currentRoundNumber! + 1}/${gameServiceProvider.game.rounds.length}',
                    style: SWTheme.regularTextStyle,
                  ),
                  const SizedBox(width: 30),
                  SWIconButton(
                    icon: Icons.close,
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        SketchWizardsRoutes.home.route,
                        (route) => false,
                      );
                    },
                  )
                ],
              ),
              bottomWidget: Center(
                child: SWTextButton(
                  text: "Ok",
                  onPressed: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                    SketchWizardsRoutes.drawRound.route,
                    (route) => false,
                  ),
                ),
              ),
              children: [
                const SizedBox(height: 50),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                            text: gameServiceProvider.currentPlayer.name,
                            style:
                                SWTheme.boldTextStyle.copyWith(fontSize: 50)),
                        TextSpan(
                            text: ', you have ${gameSettingsProvider.roundDurationToString} to draw:',
                            style: SWTheme.regularTextStyle
                                .copyWith(fontSize: 50)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    gameServiceProvider.currentWord,
                    style: SWTheme.regularTextStyle
                        .copyWith(fontSize: 150, letterSpacing: 5),
                  ).animate().slideX(
                      begin: -5,
                      curve: Curves.ease,
                      duration: 0.8.seconds,
                      delay: 0.2.seconds),
                ),
              ],
            );
          }),
    );
  }
}
