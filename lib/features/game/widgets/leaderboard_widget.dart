import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';
import 'package:sketch_wizards/theme/sw_theme.dart';

class LeaderBoardPlayer extends StatelessWidget {
  const LeaderBoardPlayer({
    super.key,
    required this.index,
    required this.player,
    required this.score,
    this.isWinner = false,
  });

  final int index;
  final SWPlayer player;
  final int score;

  final bool isWinner;

  @override
  Widget build(BuildContext context) {
    double isWinnerMagnification = isWinner ? 1.7 : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: SWTheme.textColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Text(
                '#${index + 1}',
                style: SWTheme.boldTextStyle.copyWith(
                    fontSize: SWTheme.boldTextStyle.fontSize! *
                        isWinnerMagnification),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: SizedBox(
              width: 400 * isWinnerMagnification,
              height: 120 * isWinnerMagnification,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: Text(
                    player.name,
                    style: SWTheme.regularTextStyle.copyWith(
                        fontSize: SWTheme.regularTextStyle.fontSize! *
                            isWinnerMagnification),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              decoration: BoxDecoration(
                color: SWTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$score',
                        style: SWTheme.boldTextStyle.copyWith(
                            fontSize: SWTheme.boldTextStyle.fontSize! *
                                isWinnerMagnification),
                      ),
                      TextSpan(
                        text: 'pt',
                        style: SWTheme.regularTextStyle.copyWith(
                            fontSize: SWTheme.regularTextStyle.fontSize! *
                                isWinnerMagnification),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
