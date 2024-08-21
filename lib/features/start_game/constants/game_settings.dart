class GameSettingsConstants {
  // Player count
  static const int maxPlayers = 8;
  static const int minPlayers = 1;

  // Round duration
  static const List<Duration> roundDurations = [
    Duration(seconds: 3),
    Duration(seconds: 5),
    Duration(seconds: 10),
    Duration(seconds: 20),
    Duration(seconds: 30),
  ];
  static const Duration defaultRoundDuration = Duration(seconds: 10);

  // Round number
  static const int minRoundNumber = 1;
  static const int maxRoundNumber = 10;
  static const int defaultRoundNumber = 3;
}
