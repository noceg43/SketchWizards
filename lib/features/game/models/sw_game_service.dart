import 'package:sketch_wizards/features/game/models/sw_round.dart';
import 'package:sketch_wizards/features/game/models/sw_user_round.dart';
import 'package:sketch_wizards/features/start_game/models/sw_game_settings.dart';

class SWGameService {
  final List<SWRound> rounds;

  SWGameService(SWGameSettings gameSettings, String Function() randomWord)
      : rounds = [
          for (int i = 0; i < gameSettings.roundNumber; i++)
            SWRound(
              roundNumber: i,
              userRounds: [
                for (var player in gameSettings.players)
                  SWUserRound.notStarted(player.id, i, randomWord())
              ],
            )
        ];
}
