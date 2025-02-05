import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sketch_wizards/common/service_locator/service_locator.dart';
import 'package:sketch_wizards/common/widgets/player_widget.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/common/widgets/sw_text_field.dart';
import 'package:sketch_wizards/features/start_game/constants/game_settings.dart';
import 'package:sketch_wizards/features/start_game/logic/sw_game_settings_provider.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWHome extends StatefulWidget {
  const SWHome({super.key});

  @override
  State<SWHome> createState() => _SWHomeState();
}

class _SWHomeState extends State<SWHome> {
  final swGameProvider = getIt.get<SWGameSettingsProvider>();

  final TextEditingController controller = TextEditingController();

  bool get textFieldFilled => controller.text.replaceAll(' ', '').isNotEmpty;

  void onAddPlayerPressed() {
    if (textFieldFilled) {
      int newId = swGameProvider.game.players.isNotEmpty
          ? [for (final player in swGameProvider.game.players) player.id]
                  .reduce(max) +
              1
          : 1;

      // remove last spaces
      String playerName = controller.text.trimRight();
      swGameProvider.addPlayer(
        SWPlayer(
          id: newId,
          name: playerName,
        ),
      );
      controller.clear();
    }
  }

  void onStartGamePressed() =>
      Navigator.pushNamed(context, SketchWizardsRoutes.gameOptions.route);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: swGameProvider,
      builder: (context, _) {
        String title = (swGameProvider.game.players.isEmpty)
            ? 'Hi there! Let\'s play Sketch Wizards!, Add just one player to start'
            : (swGameProvider.game.players.length == 1)
                ? 'Hi ${swGameProvider.game.players.first.name}! Are you ready to play?'
                : (swGameProvider.game.players.length ==
                        GameSettingsConstants.maxPlayers)
                    ? 'We are full! Press Start Game to begin'
                    : 'Hi ${swGameProvider.game.players.last.name} and ${swGameProvider.game.players.length - 1} more, let\'s play Sketch Wizards!';

        return SWScaffold(
          title: title,
          bottomWidget: Center(
            child: SWTextButton(
              text: 'Start Game',
              onPressed: onStartGamePressed,
              enabled: swGameProvider.game.players.isNotEmpty,
              key: ValueKey(
                  "start_game_button_${swGameProvider.game.players.isNotEmpty}"),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: 800,
                child: Row(
                  children: [
                    Expanded(
                      child: SWTextField(
                        controller: controller,
                        hintText: 'Enter here the player name',
                        onDone: onAddPlayerPressed,
                        enabled: swGameProvider.game.players.length <
                            GameSettingsConstants.maxPlayers,
                        inputFormatters: [
                          // avoid first space
                          FilteringTextInputFormatter.deny(RegExp(r'^\s')),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    SWIconButton(
                      icon: Icons.add,
                      onPressed: onAddPlayerPressed,
                      enabled: swGameProvider.game.players.length <
                          GameSettingsConstants.maxPlayers,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 300,
              ),
              child: swGameProvider.game.players.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: const Text(
                        "Sketch Wizards",
                        style: TextStyle(
                          fontSize: 250,
                          color: SWTheme.primaryColor,
                        ),
                      )
                          .animate()
                          .slideX(duration: 300.milliseconds)
                          .shakeX(delay: 300.milliseconds)
                          .animate(
                        delay: 1.seconds,
                        onPlay: (controller) => controller.repeat(),
                        effects: [
                          ShimmerEffect(
                            duration: 5.seconds,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 100,
                        runSpacing: 50,
                        children: [
                          for (final player in swGameProvider.game.players)
                            PlayerWidget(
                              text: player.name,
                              onDelete: () =>
                                  swGameProvider.removePlayer(player),
                            )
                        ],
                      ).animate().slideY(
                          begin: -5,
                          curve: Curves.elasticOut,
                          duration: 1.seconds),
                    ),
            ),
          ],
        );
      },
    );
  }
}
