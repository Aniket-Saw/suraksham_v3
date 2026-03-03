/// Represents the state of the flood simulation game.
enum GamePhase { preparing, flooding, results }

class SimulationGameState {
  final GamePhase phase;
  final double waterLevel; // 0.0 to 1.0
  final int score;
  final int sandbagCount;
  final int kitCount;
  final int totalItemsPlaced;
  final double timeRemaining; // seconds
  final bool isGameOver;

  const SimulationGameState({
    this.phase = GamePhase.preparing,
    this.waterLevel = 0.0,
    this.score = 0,
    this.sandbagCount = 0,
    this.kitCount = 0,
    this.totalItemsPlaced = 0,
    this.timeRemaining = 60.0,
    this.isGameOver = false,
  });

  SimulationGameState copyWith({
    GamePhase? phase,
    double? waterLevel,
    int? score,
    int? sandbagCount,
    int? kitCount,
    int? totalItemsPlaced,
    double? timeRemaining,
    bool? isGameOver,
  }) {
    return SimulationGameState(
      phase: phase ?? this.phase,
      waterLevel: waterLevel ?? this.waterLevel,
      score: score ?? this.score,
      sandbagCount: sandbagCount ?? this.sandbagCount,
      kitCount: kitCount ?? this.kitCount,
      totalItemsPlaced: totalItemsPlaced ?? this.totalItemsPlaced,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }

  /// Calculate the resilience score (0 - 100) based on the game outcome.
  int get resilienceScore {
    final sandbagScore = (sandbagCount * 10).clamp(0, 40);
    final kitScore = (kitCount * 15).clamp(0, 30);
    final timeBonus = (timeRemaining * 0.5).clamp(0, 30).toInt();
    return (sandbagScore + kitScore + timeBonus).clamp(0, 100);
  }
}
