import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/game_state.dart';
import '../game/flood_simulation_game.dart';
import 'game_provider.dart';

class SimulationScreen extends ConsumerStatefulWidget {
  const SimulationScreen({super.key});

  @override
  ConsumerState<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends ConsumerState<SimulationScreen>
    with SingleTickerProviderStateMixin {
  FloodSimulationGame? _game;
  bool _gameStarted = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
      body: _gameStarted
          ? Stack(
              children: [
                GameWidget(game: _game!),
                _buildHUD(context, gameState, theme),
                if (gameState.isGameOver)
                  _buildResults(context, gameState, theme),
              ],
            )
          : _buildStartScreen(context, theme),
    );
  }

  // ── Start Screen ──────────────────────────────────────────────────
  Widget _buildStartScreen(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.nightGradient),
      child: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Animated water icon with glow
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final scale = 1.0 + _pulseController.value * 0.08;
                final glowOpacity = 0.15 + _pulseController.value * 0.15;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.lavender.withOpacity(0.15),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lavender.withOpacity(glowOpacity),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.water_drop_rounded,
                      size: 56,
                      color: AppColors.lavender.withOpacity(0.9),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              'Flood Simulation',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'You have 60 seconds to prepare your house for a flood.\n\n'
                '🪨 Drag sandbags to reduce water damage\n'
                '🩹 Place first aid kits for safety points\n\n'
                'The flood starts rising at 30 seconds!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  height: 1.6,
                ),
              ),
            ),
            const Spacer(),
            // Start button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.indigo.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _startGame,
                  icon: const Icon(Icons.play_arrow_rounded, size: 28),
                  label: const Text('START SIMULATION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  // ── HUD Overlay ───────────────────────────────────────────────────
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
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.85),
              Colors.black.withOpacity(0.0),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _hudPill(
                Icons.water_drop_rounded,
                '${(gameState.waterLevel * 100).toInt()}%',
                const Color(0xFF64B5F6),
              ),
              _hudPill(
                Icons.inventory_2_rounded,
                '${gameState.sandbagCount}',
                const Color(0xFFD4A574),
              ),
              _hudPill(
                Icons.medical_services_rounded,
                '${gameState.kitCount}',
                const Color(0xFF81C784),
              ),
              _hudPill(
                Icons.star_rounded,
                '${gameState.score}',
                const Color(0xFFFFD54F),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hudPill(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ── Results Overlay ───────────────────────────────────────────────
  Widget _buildResults(
    BuildContext context,
    SimulationGameState gameState,
    ThemeData theme,
  ) {
    final resilienceScore = gameState.resilienceScore;
    final scoreColor = resilienceScore >= 70
        ? const Color(0xFF66BB6A)
        : resilienceScore >= 40
        ? const Color(0xFFFFA726)
        : const Color(0xFFEF5350);
    final scoreEmoji = resilienceScore >= 70
        ? '🏆'
        : resilienceScore >= 40
        ? '👍'
        : '⚠️';
    final scoreLabel = resilienceScore >= 70
        ? 'Excellent!'
        : resilienceScore >= 40
        ? 'Good Effort'
        : 'Needs Improvement';

    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(28),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1B2838)
                : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Score badge
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: scoreColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(scoreEmoji, style: const TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Simulation Complete!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                scoreLabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: scoreColor,
                ),
              ),
              const SizedBox(height: 24),
              // Stats
              _resultRow('Sandbags Placed', '${gameState.sandbagCount}', theme),
              _resultRow('First Aid Kits', '${gameState.kitCount}', theme),
              _resultRow('Items Total', '${gameState.totalItemsPlaced}', theme),
              Divider(color: theme.dividerTheme.color, height: 24),
              _resultRow(
                'Resilience Score',
                '$resilienceScore / 100',
                theme,
                bold: true,
                color: scoreColor,
              ),
              const SizedBox(height: 28),
              // Action buttons
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(gameStateProvider.notifier).resetGame();
                          context.pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: const Text('DONE'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(
    String label,
    String value,
    ThemeData theme, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: color ?? theme.colorScheme.onSurface,
              fontSize: bold ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
