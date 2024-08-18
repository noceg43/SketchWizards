enum SWUserRoundStatus { notStarted, inProgress, guessed, failed }

class SWUserRound {
  final int userId;
  final int roundNumber;
  final int score;
  final String word;
  final SWUserRoundStatus status;
  SWUserRound({
    required this.userId,
    required this.roundNumber,
    required this.score,
    required this.word,
    required this.status,
  });


  // not started user round
  factory SWUserRound.notStarted(int userId, int roundNumber, String word) {
    return SWUserRound(
      userId: userId,
      roundNumber: roundNumber,
      score: 0,
      word: word,
      status: SWUserRoundStatus.notStarted,
    );
  }

  SWUserRound copyWith({
    int? userId,
    int? roundNumber,
    int? score,
    String? word,
    SWUserRoundStatus? status,
  }) {
    return SWUserRound(
      userId: userId ?? this.userId,
      roundNumber: roundNumber ?? this.roundNumber,
      score: score ?? this.score,
      word: word ?? this.word,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'SWUserRound(userId: $userId, roundNumber: $roundNumber, score: $score, word: $word, status: $status)';
  }

  @override
  bool operator ==(covariant SWUserRound other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.roundNumber == roundNumber &&
        other.score == score &&
        other.word == word &&
        other.status == status;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        roundNumber.hashCode ^
        score.hashCode ^
        word.hashCode ^
        status.hashCode;
  }
}
