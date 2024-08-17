import 'package:flutter/foundation.dart';
import 'package:sketch_wizards/features/start_game/constants/game_settings.dart';
import 'package:sketch_wizards/features/start_game/models/sw_game.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';

class SWGameService extends ChangeNotifier {
  SWGame _game;

  // default constructor with initial game state
  SWGameService()
      : _game = SWGame(
          players: [],
          roundNumber: GameSettingsConstants.defaultRoundNumber,
          roundDuration: GameSettingsConstants.defaultRoundDuration,
        );

  SWGame get game => _game;

  void addPlayer(SWPlayer player) {
    _game = _game.copyWith(players: [..._game.players, player]);
    notifyListeners();
  }

  void removePlayer(SWPlayer player) {
    _game.players.remove(player);
    notifyListeners();
  }

  void updatePlayers(List<SWPlayer> players) {
    _game = _game.copyWith(players: players);
    notifyListeners();
  }

  void updateRoundNumber(int roundNumber) {
    _game = _game.copyWith(roundNumber: roundNumber);
    notifyListeners();
  }

  void updateRoundDuration(Duration roundDuration) {
    _game = _game.copyWith(roundDuration: roundDuration);
    notifyListeners();
  }

  String get roundDurationToString {
    int durationInSeconds = _game.roundDuration.inSeconds;

    if (durationInSeconds >= 60) {
      int minutes = durationInSeconds ~/ 60;
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    } else {
      return '$durationInSeconds second${durationInSeconds > 1 ? 's' : ''}';
    }
  }
}
