import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Animated water surface that rises during the flood phase.
class WaterComponent extends PositionComponent {
  double _waveOffset = 0;
  double _targetHeight = 0;
  final Paint _waterPaint = Paint()..color = const Color(0x882196F3);
  final Paint _wavePaint = Paint()..color = const Color(0xAA42A5F5);

  WaterComponent({required super.position, required super.size})
    : super(priority: 5);

  void updateLevel(double height) {
    _targetHeight = height;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _waveOffset += dt * 2;

    // Smoothly animate the water level
    final parentHeight = findGame()!.canvasSize.y;
    final targetY = parentHeight - _targetHeight;
    final targetSize = _targetHeight;

    position.y += (targetY - position.y) * 0.05;
    size.y += (targetSize - size.y) * 0.05;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Main water body
    canvas.drawRect(Rect.fromLTWH(0, 10, size.x, size.y), _waterPaint);

    // Draw wave crests
    final wavePath = Path();
    wavePath.moveTo(0, 0);
    for (double x = 0; x <= size.x; x += 5) {
      final y =
          sin((x / 30) + _waveOffset) * 5 +
          sin((x / 15) + _waveOffset * 1.5) * 3;
      wavePath.lineTo(x, y);
    }
    wavePath.lineTo(size.x, size.y);
    wavePath.lineTo(0, size.y);
    wavePath.close();

    canvas.drawPath(wavePath, _wavePaint);
  }
}
