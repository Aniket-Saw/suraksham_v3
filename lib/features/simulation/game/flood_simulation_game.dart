import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'components/water_component.dart';
import 'components/sandbag_component.dart';
import 'components/kit_component.dart';
import 'components/house_component.dart';
import 'components/ground_component.dart';
import 'components/item_spawn_area.dart';

/// The main Flame game for the flood disaster simulation.
class FloodSimulationGame extends FlameGame with HasCollisionDetection {
  // Callbacks to bridge game events back to Riverpod
  final VoidCallback onSandbagPlaced;
  final VoidCallback onKitPlaced;
  final ValueChanged<double> onWaterLevelChanged;
  final ValueChanged<double> onTimerTick;
  final VoidCallback onGameOver;

  late WaterComponent _water;
  late HouseComponent _house;
  late GroundComponent _ground;
  late ItemSpawnArea _sandbagSpawn;
  late ItemSpawnArea _kitSpawn;
  late TextComponent _timerText;
  late TextComponent _instructionText;

  double _timeRemaining = 60.0;
  bool _isFloodPhase = false;
  bool _isGameOver = false;
  int _sandbagCount = 0;
  int _kitCount = 0;

  // Maximum items the player can place
  static const int maxSandbags = 6;
  static const int maxKits = 3;

  FloodSimulationGame({
    required this.onSandbagPlaced,
    required this.onKitPlaced,
    required this.onWaterLevelChanged,
    required this.onTimerTick,
    required this.onGameOver,
  });

  @override
  Color backgroundColor() => const Color(0xFF1A1A2E);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Ground / terrain
    _ground = GroundComponent(
      position: Vector2(0, size.y * 0.75),
      size: Vector2(size.x, size.y * 0.25),
    );
    add(_ground);

    // House to protect
    _house = HouseComponent(
      position: Vector2(size.x * 0.5 - 50, size.y * 0.75 - 90),
      size: Vector2(100, 90),
    );
    add(_house);

    // Water (starts off-screen at the bottom)
    _water = WaterComponent(
      position: Vector2(0, size.y),
      size: Vector2(size.x, 0),
    );
    add(_water);

    // Sandbag spawn area (left side)
    _sandbagSpawn = ItemSpawnArea(
      position: Vector2(20, size.y * 0.15),
      size: Vector2(80, 80),
      label: 'Sandbags',
      iconColor: const Color(0xFFD4A574),
      itemIcon: '🪨',
      maxItems: maxSandbags,
      onDragComplete: _onSandbagDragComplete,
    );
    add(_sandbagSpawn);

    // Kit spawn area (right side)
    _kitSpawn = ItemSpawnArea(
      position: Vector2(size.x - 100, size.y * 0.15),
      size: Vector2(80, 80),
      label: 'First Aid',
      iconColor: const Color(0xFF4CAF50),
      itemIcon: '🩹',
      maxItems: maxKits,
      onDragComplete: _onKitDragComplete,
    );
    add(_kitSpawn);

    // Timer display
    _timerText = TextComponent(
      text: '60s',
      position: Vector2(size.x / 2, 20),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
    add(_timerText);

    // Instruction text
    _instructionText = TextComponent(
      text: 'Drag items to protect the house!',
      position: Vector2(size.x / 2, 55),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(fontSize: 14, color: Colors.white70),
      ),
    );
    add(_instructionText);
  }

  void _onSandbagDragComplete(Vector2 dropPosition) {
    if (_isGameOver || _sandbagCount >= maxSandbags) return;

    // Only count if dropped near the ground/house area
    if (dropPosition.y > size.y * 0.55) {
      final sandbag = SandbagComponent(
        position: dropPosition,
        size: Vector2(40, 25),
      );
      add(sandbag);
      _sandbagCount++;
      onSandbagPlaced();
    }
  }

  void _onKitDragComplete(Vector2 dropPosition) {
    if (_isGameOver || _kitCount >= maxKits) return;

    // Only count if dropped near the house area
    final houseCenter = _house.position + _house.size / 2;
    final distance = dropPosition.distanceTo(houseCenter);
    if (distance < 120) {
      final kit = KitComponent(position: dropPosition, size: Vector2(30, 30));
      add(kit);
      _kitCount++;
      onKitPlaced();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_isGameOver) return;

    // Countdown
    _timeRemaining -= dt;
    onTimerTick(_timeRemaining);

    if (_timeRemaining <= 0) {
      _timeRemaining = 0;
      _isGameOver = true;
      onGameOver();
      return;
    }

    _timerText.text = '${_timeRemaining.toInt()}s';

    // Start flooding after 30 seconds or midway
    if (_timeRemaining <= 30 && !_isFloodPhase) {
      _isFloodPhase = true;
      _instructionText.text = 'The flood is rising!';
    }

    if (_isFloodPhase) {
      // Water rises over the remaining time
      final progress = (30 - _timeRemaining) / 30.0;
      final maxRise = size.y * 0.35; // water covers 35% of screen max

      // Sandbags reduce the max water level
      final sandbagProtection = _sandbagCount * 0.06; // each sandbag reduces 6%
      final effectiveRise =
          maxRise * (progress * (1.0 - sandbagProtection)).clamp(0.0, 1.0);

      _water.updateLevel(effectiveRise);
      onWaterLevelChanged(progress * (1.0 - sandbagProtection));
    }
  }
}
