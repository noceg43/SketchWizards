import 'package:flutter/foundation.dart';

import 'package:sketch_wizards/features/start_game/models/sw_player.dart';

class SWGame {
  final List<SWPlayer> players;
  final int roundNumber;
  final Duration roundDuration;
  SWGame({
    required this.players,
    required this.roundNumber,
    required this.roundDuration,
  });

  SWGame copyWith({
    List<SWPlayer>? players,
    int? roundNumber,
    Duration? roundDuration,
  }) {
    return SWGame(
      players: players ?? this.players,
      roundNumber: roundNumber ?? this.roundNumber,
      roundDuration: roundDuration ?? this.roundDuration,
    );
  }

  @override
  String toString() =>
      'SWGame(players: $players, roundNumber: $roundNumber, roundDuration: $roundDuration)';

  @override
  bool operator ==(covariant SWGame other) {
    if (identical(this, other)) return true;

    return listEquals(other.players, players) &&
        other.roundNumber == roundNumber &&
        other.roundDuration == roundDuration;
  }

  @override
  int get hashCode =>
      players.hashCode ^ roundNumber.hashCode ^ roundDuration.hashCode;
}
