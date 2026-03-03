import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// The house component that the player must protect from the flood.
class HouseComponent extends PositionComponent {
  final Paint _wallPaint = Paint()..color = const Color(0xFF795548);
  final Paint _roofPaint = Paint()..color = const Color(0xFFBF360C);
  final Paint _doorPaint = Paint()..color = const Color(0xFF4E342E);
  final Paint _windowPaint = Paint()..color = const Color(0xFF81D4FA);

  HouseComponent({required super.position, required super.size})
    : super(priority: 8);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // House walls
    canvas.drawRect(
      Rect.fromLTWH(0, size.y * 0.35, size.x, size.y * 0.65),
      _wallPaint,
    );

    // Roof (triangle)
    final roofPath = Path()
      ..moveTo(size.x / 2, 0)
      ..lineTo(-10, size.y * 0.4)
      ..lineTo(size.x + 10, size.y * 0.4)
      ..close();
    canvas.drawPath(roofPath, _roofPaint);

    // Door
    canvas.drawRect(
      Rect.fromLTWH(size.x * 0.4, size.y * 0.6, size.x * 0.2, size.y * 0.4),
      _doorPaint,
    );

    // Window left
    canvas.drawRect(
      Rect.fromLTWH(size.x * 0.1, size.y * 0.45, size.x * 0.2, size.y * 0.2),
      _windowPaint,
    );

    // Window right
    canvas.drawRect(
      Rect.fromLTWH(size.x * 0.7, size.y * 0.45, size.x * 0.2, size.y * 0.2),
      _windowPaint,
    );
  }
}
