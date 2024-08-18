import 'package:flutter/foundation.dart';

import 'package:sketch_wizards/features/game/models/sw_user_round.dart';

class SWRound {
  final int roundNumber;
  final List<SWUserRound> userRounds;
  SWRound({
    required this.roundNumber,
    required this.userRounds,
  });

  SWRound copyWith({
    int? roundNumber,
    List<SWUserRound>? userRounds,
  }) {
    return SWRound(
      roundNumber: roundNumber ?? this.roundNumber,
      userRounds: userRounds ?? this.userRounds,
    );
  }

  @override
  String toString() =>
      'SWRound(roundNumber: $roundNumber, userRounds: $userRounds)';

  @override
  bool operator ==(covariant SWRound other) {
    if (identical(this, other)) return true;

    return other.roundNumber == roundNumber &&
        listEquals(other.userRounds, userRounds);
  }

  @override
  int get hashCode => roundNumber.hashCode ^ userRounds.hashCode;
}
