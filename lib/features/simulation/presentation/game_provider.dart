import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/game_state.dart';

/// The main Riverpod provider that bridges the Flame game state with Flutter UI.
final gameStateProvider =
    NotifierProvider<GameStateNotifier, SimulationGameState>(
      GameStateNotifier.new,
    );

class GameStateNotifier extends Notifier<SimulationGameState> {
  @override
  SimulationGameState build() => const SimulationGameState();

  void startPreparing() {
    state = const SimulationGameState(
      phase: GamePhase.preparing,
      timeRemaining: 60.0,
    );
  }

  void startFlooding() {
    state = state.copyWith(phase: GamePhase.flooding);
  }

  void placeSandbag() {
    state = state.copyWith(
      sandbagCount: state.sandbagCount + 1,
      totalItemsPlaced: state.totalItemsPlaced + 1,
      score: state.score + 10,
    );
  }

  void placeKit() {
    state = state.copyWith(
      kitCount: state.kitCount + 1,
      totalItemsPlaced: state.totalItemsPlaced + 1,
      score: state.score + 15,
    );
  }

  void updateWaterLevel(double level) {
    state = state.copyWith(waterLevel: level.clamp(0.0, 1.0));
  }

  void updateTimer(double remaining) {
    if (remaining <= 0) {
      endGame();
      return;
    }
    state = state.copyWith(timeRemaining: remaining);
  }

  void endGame() {
    state = state.copyWith(
      phase: GamePhase.results,
      isGameOver: true,
      timeRemaining: 0,
    );
  }

  void resetGame() {
    state = const SimulationGameState();
  }
}
