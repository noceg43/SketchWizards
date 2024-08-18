import 'package:flutter/material.dart';
import 'package:sketch_wizards/common/service_locator/service_locator.dart';
import 'package:sketch_wizards/common/widgets/player_widget.dart';
import 'package:sketch_wizards/common/widgets/sw_icon_button.dart';
import 'package:sketch_wizards/common/widgets/sw_scaffold.dart';
import 'package:sketch_wizards/common/widgets/sw_text_button.dart';
import 'package:sketch_wizards/features/game/logic/sw_game_service_provider.dart';
import 'package:sketch_wizards/features/start_game/constants/game_settings.dart';
import 'package:sketch_wizards/features/start_game/logic/sw_game_settings_provider.dart';
import 'package:sketch_wizards/sw_router.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class SWGameOptions extends StatefulWidget {
  const SWGameOptions({super.key});

  @override
  State<SWGameOptions> createState() => _SWGameOptionsState();
}

class _SWGameOptionsState extends State<SWGameOptions> {
  @override
  Widget build(BuildContext context) {
    final swGameProvider = getIt.get<SWGameSettingsProvider>();

    final ValueNotifier<double> roundDuration = ValueNotifier(
        GameSettingsConstants.roundDurations
            .indexOf(swGameProvider.game.roundDuration)
            .toDouble());

    final ValueNotifier<double> roundNumber =
        ValueNotifier(swGameProvider.game.roundNumber.toDouble());

    void onRoundDurationChanged(double value) {
      roundDuration.value = value;

      final duration = GameSettingsConstants.roundDurations[value.toInt()];
      swGameProvider.updateRoundDuration(duration);
    }

    void onRoundNumberChanged(double value) {
      roundNumber.value = value;
      swGameProvider.updateRoundNumber(value.toInt());
    }

    void onStartGamePressed() {
      final swGameServiceProvider = getIt.get<SWGameServiceProvider>();
      swGameServiceProvider.initGame(swGameProvider.game);
      Navigator.pushNamed(context, SketchWizardsRoutes.roundIntro.route);
    }

    return SWScaffold(
      showBackButton: true,
      title: 'Sketch Wizards',
      bottomWidget: Center(
        child: SWTextButton(
          text: 'Start Game',
          onPressed: onStartGamePressed,
          enabled: swGameProvider.game.players.isNotEmpty,
        ),
      ),
      children: [
        const SizedBox(height: 75),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 100,
                  runSpacing: 30,
                  children: [
                    for (final player in swGameProvider.game.players)
                      PlayerWidget(
                        text: player.name,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 100),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Match Settings:",
                    style: SWTheme.regularTextStyle,
                  ),
                  const SizedBox(height: 100),

                  // Round duration
                  Text(
                    "Round duration",
                    style: SWTheme.regularTextStyle,
                  ),
                  const SizedBox(height: 30),
                  ListenableBuilder(
                    listenable: roundDuration,
                    builder: (context, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: SWSlider(
                              min: 0,
                              max: GameSettingsConstants.roundDurations.length
                                      .toDouble() -
                                  1,
                              value: roundDuration.value,
                              onChanged: onRoundDurationChanged,
                              onDecrease: () {
                                if (roundDuration.value > 0) {
                                  roundDuration.value -= 1;
                                  onRoundDurationChanged(roundDuration.value);
                                }
                              },
                              onIncrease: () {
                                if (roundDuration.value <
                                    GameSettingsConstants
                                            .roundDurations.length -
                                        1) {
                                  roundDuration.value += 1;
                                  onRoundDurationChanged(roundDuration.value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 50),
                          Text(
                            swGameProvider.roundDurationToString,
                            style: SWTheme.regularTextStyle,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 100),

                  // Round number
                  Text(
                    "Round number",
                    style: SWTheme.regularTextStyle,
                  ),
                  const SizedBox(height: 30),
                  ListenableBuilder(
                    listenable: roundNumber,
                    builder: (context, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: SWSlider(
                              min: GameSettingsConstants.minRoundNumber
                                  .toDouble(),
                              max: GameSettingsConstants.maxRoundNumber
                                  .toDouble(),
                              value: roundNumber.value,
                              onChanged: onRoundNumberChanged,
                              onDecrease: () {
                                if (roundNumber.value >
                                    GameSettingsConstants.minRoundNumber) {
                                  roundNumber.value -= 1;
                                  onRoundNumberChanged(roundNumber.value);
                                }
                              },
                              onIncrease: () {
                                if (roundNumber.value <
                                    GameSettingsConstants.maxRoundNumber) {
                                  roundNumber.value += 1;
                                  onRoundNumberChanged(roundNumber.value);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 50),
                          Text(
                            "${roundNumber.value.toInt()} round${roundNumber.value.toInt() > 1 ? 's' : ''}",
                            style: SWTheme.regularTextStyle,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ],
    );
  }
}

class SWSlider extends StatefulWidget {
  const SWSlider({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    this.step = 1,
    required this.onChanged,
    this.showIconButtons = true,
    this.onDecrease,
    this.onIncrease,
  });
  final double min;
  final double max;
  final double value;
  final double step;
  final Function(double) onChanged;
  final bool showIconButtons;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  State<SWSlider> createState() => SWSliderState();
}

class SWSliderState extends State<SWSlider> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Widget slider = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _isHovered = hasFocus;
          });
        },
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 30,
              elevation: 0,
              pressedElevation: 0,
            ),
            trackHeight: 20,
            thumbColor: SWTheme.primaryColor,
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 35),
            overlayColor: _isHovered ? Colors.white : Colors.transparent,
            activeTrackColor: SWTheme.primaryColor,
            inactiveTrackColor: SWTheme.textColor,
          ),
          child: Slider(
            min: widget.min,
            max: widget.max,
            value: widget.value,
            divisions: (widget.max - widget.min).toInt(),
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );

    if (widget.showIconButtons) {
      return Row(
        children: [
          SWIconButton(
            icon: Icons.remove,
            onPressed: widget.onDecrease,
            smallIcon: true,
          ),
          Expanded(child: slider),
          SWIconButton(
            icon: Icons.add,
            onPressed: widget.onIncrease,
            smallIcon: true,
          ),
        ],
      );
    } else {
      return slider;
    }
  }
}
