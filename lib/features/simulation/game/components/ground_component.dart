import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The terrain / ground surface component.
class GroundComponent extends PositionComponent {
  final Paint _groundPaint = Paint()..color = const Color(0xFF2E7D32);
  final Paint _dirtPaint = Paint()..color = const Color(0xFF5D4037);

  GroundComponent({required super.position, required super.size})
    : super(priority: 3);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Dirt layer
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), _dirtPaint);

    // Grass top
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, 8), _groundPaint);
  }
}
