import 'package:flutter/material.dart';
import 'package:sketch_wizards/features/game/models/sw_game_service.dart';
import 'package:sketch_wizards/features/game/models/sw_round.dart';
import 'package:sketch_wizards/features/game/models/sw_user_round.dart';
import 'package:sketch_wizards/features/game/repository/sw_word_repository.dart';
import 'package:sketch_wizards/features/start_game/models/sw_game_settings.dart';
import 'package:sketch_wizards/features/start_game/models/sw_player.dart';

//TODO refactor this class using less methods
class SWGameServiceProvider extends ChangeNotifier {
  int? currentRoundNumber;
  int? _currentPlayerId;
  SWGameService? _game;

  // save the game settings on the game service provider
  SWGameSettings? _gameSettings;

  SWGameServiceProvider();

  SWGameService get game =>
      (_game == null) ? throw Exception('Game not initialized') : _game!;

  void initGame(SWGameSettings gameSettings) {
    _gameSettings = gameSettings;
    _game = SWGameService(
        gameSettings, () => SketchWizardsWordRepository.getRandomLabel());
    currentRoundNumber = 0;
    _currentPlayerId = gameSettings.players.first.id;
    notifyListeners();
  }

  void resetGame() {
    _game = null;
    _gameSettings = null;
    currentRoundNumber = null;
    _currentPlayerId = null;
    notifyListeners();
  }

  void nextRound() {
    if (currentRoundNumber! < game.rounds.length - 1) {
      currentRoundNumber = currentRoundNumber! + 1;
      _currentPlayerId =
          game.rounds[currentRoundNumber!].userRounds.first.userId;
      notifyListeners();
    }
  }

  void nextPlayer() {
    if (_game!.rounds[currentRoundNumber!].userRounds.every(
        (userRound) => userRound.status != SWUserRoundStatus.notStarted)) {
      nextRound();
    } else {
      _currentPlayerId = _game!.rounds[currentRoundNumber!].userRounds
          .firstWhere(
              (userRound) => userRound.status == SWUserRoundStatus.notStarted)
          .userId;
      notifyListeners();
    }
  }

  void setCurrentUserRound(SWUserRoundStatus status, {int? score}) {
    final userRound = currentUserRound;
    int index =
        _game!.rounds[currentRoundNumber!].userRounds.indexOf(userRound);
    _game!.rounds[currentRoundNumber!].userRounds.remove(userRound);
    _game!.rounds[currentRoundNumber!].userRounds
        .insert(index, userRound.copyWith(status: status, score: score));
    notifyListeners();
  }

  Duration get roundDuration => _gameSettings!.roundDuration;

  SWPlayer get currentPlayer => _gameSettings!.players
      .firstWhere((player) => player.id == _currentPlayerId);

  String get currentWord => _game!.rounds[currentRoundNumber!].userRounds
      .firstWhere((userRound) => userRound.userId == _currentPlayerId)
      .word;

  SWUserRound get currentUserRound =>
      _game!.rounds[currentRoundNumber!].userRounds
          .firstWhere((userRound) => userRound.userId == _currentPlayerId);

  bool get isCurrentRoundFinished => _game!
      .rounds[currentRoundNumber!].userRounds
      .every((userRound) => userRound.status != SWUserRoundStatus.notStarted);

  bool get isGameFinished => _game!.rounds.every((round) => round.userRounds
      .every((userRound) => userRound.status != SWUserRoundStatus.notStarted));

  SWRound get currentRound => _game!.rounds[currentRoundNumber!];

  // get the player with the highest score for the current round
  SWPlayer get currentMVPplayer {
    final userRounds = _game!.rounds[currentRoundNumber!].userRounds;
    final maxScore = userRounds
        .map((userRound) => userRound.score)
        .reduce((a, b) => a > b ? a : b);

    int mvpId = userRounds
        .firstWhere((userRound) => userRound.score == maxScore)
        .userId;

    return _gameSettings!.players.firstWhere((player) => player.id == mvpId);
  }

  // players scores of all rounds sorted by the player's score
  Map<SWPlayer, int> get playersScores {
    final playersScores = <SWPlayer, int>{};
    for (final player in _gameSettings!.players) {
      final score = _game!.rounds
          .map((round) => round.userRounds
              .firstWhere((userRound) => userRound.userId == player.id)
              .score)
          .reduce((a, b) => a + b);
      playersScores[player] = score;
    }
    // Convert map entries to a list and sort by score
    final sortedEntries = playersScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Convert sorted list back to a map
    return Map<SWPlayer, int>.fromEntries(sortedEntries);
  }
}
