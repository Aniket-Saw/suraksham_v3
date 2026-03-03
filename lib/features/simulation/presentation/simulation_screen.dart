import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/game_state.dart';
import '../game/flood_simulation_game.dart';
import 'game_provider.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen> {
  FloodSimulationGame? _game;
  bool _gameStarted = false;

  void _startGame() {
    final notifier = ref.read(gameStateProvider.notifier);
    notifier.startPreparing();

    setState(() {
      _game = FloodSimulationGame(
        onSandbagPlaced: () => Future.microtask(() => notifier.placeSandbag()),
        onKitPlaced: () => Future.microtask(() => notifier.placeKit()),
        onWaterLevelChanged: (level) =>
            Future.microtask(() => notifier.updateWaterLevel(level)),
        onTimerTick: (remaining) =>
            Future.microtask(() => notifier.updateTimer(remaining)),
        onGameOver: () => Future.microtask(() => notifier.endGame()),
      );
      _gameStarted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flood Simulation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(gameStateProvider.notifier).resetGame();
            context.pop();
          },
        ),
      ),
      body: _gameStarted
          ? Stack(
              children: [
                // The Flame Game
                GameWidget(game: _game!),

                // HUD Overlay
                _buildHUD(context, gameState, theme),

                // Results Overlay
                if (gameState.isGameOver)
                  _buildResults(context, gameState, theme),
              ],
            )
          : _buildStartScreen(context, theme),
    );
  }

  Widget _buildStartScreen(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.water_drop, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text('Flood Simulation', style: theme.textTheme.displayMedium),
            const SizedBox(height: 16),
            Text(
              'You have 60 seconds to prepare your house for a flood.\n\n'
              '🪨 Drag sandbags around your house to reduce water damage.\n'
              '🩹 Place first aid kits near the house for safety points.\n\n'
              'The flood starts rising at 30 seconds!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _startGame,
              icon: const Icon(Icons.play_arrow),
              label: const Text('START SIMULATION'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHUD(
    BuildContext context,
    SimulationGameState gameState,
    ThemeData theme,
  ) {
    if (gameState.isGameOver) return const SizedBox.shrink();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _hudItem(
              Icons.water_drop,
              'Water',
              '${(gameState.waterLevel * 100).toInt()}%',
              Colors.blue,
            ),
            _hudItem(
              Icons.inventory_2,
              'Sandbags',
              '${gameState.sandbagCount}',
              const Color(0xFFD4A574),
            ),
            _hudItem(
              Icons.medical_services,
              'Kits',
              '${gameState.kitCount}',
              Colors.green,
            ),
            _hudItem(Icons.star, 'Score', '${gameState.score}', Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _hudItem(IconData icon, String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildResults(
    BuildContext context,
    SimulationGameState gameState,
    ThemeData theme,
  ) {
    final resilienceScore = gameState.resilienceScore;
    final scoreColor = resilienceScore >= 70
        ? Colors.green
        : resilienceScore >= 40
        ? Colors.orange
        : Colors.red;
    final scoreLabel = resilienceScore >= 70
        ? 'Excellent!'
        : resilienceScore >= 40
        ? 'Good Effort'
        : 'Needs Improvement';

    return Container(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  resilienceScore >= 70
                      ? Icons.emoji_events
                      : resilienceScore >= 40
                      ? Icons.thumb_up
                      : Icons.warning,
                  size: 56,
                  color: scoreColor,
                ),
                const SizedBox(height: 16),
                Text('Simulation Complete!', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  scoreLabel,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Score Breakdown
                _resultRow('Sandbags Placed', '${gameState.sandbagCount}'),
                _resultRow('First Aid Kits', '${gameState.kitCount}'),
                _resultRow('Items Total', '${gameState.totalItemsPlaced}'),
                const Divider(),
                _resultRow(
                  'Resilience Score',
                  '$resilienceScore / 100',
                  bold: true,
                  color: scoreColor,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          ref.read(gameStateProvider.notifier).resetGame();
                          setState(() {
                            _game = null;
                            _gameStarted = false;
                          });
                        },
                        child: const Text('RETRY'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(gameStateProvider.notifier).resetGame();
                          context.pop();
                        },
                        child: const Text('DONE'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultRow(
    String label,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: color,
              fontSize: bold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
