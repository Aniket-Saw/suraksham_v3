import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A sandbag placed by the user to protect the house from flooding.
class SandbagComponent extends PositionComponent {
  final Paint _bagPaint = Paint()..color = const Color(0xFFD4A574);
  final Paint _ropePaint = Paint()
    ..color = const Color(0xFF8B6914)
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  SandbagComponent({required super.position, required super.size})
    : super(priority: 10, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Sandbag body
    final bag = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(6),
    );
    canvas.drawRRect(bag, _bagPaint);

    // Rope/tie lines
    canvas.drawLine(
      Offset(size.x * 0.3, 0),
      Offset(size.x * 0.3, size.y),
      _ropePaint,
    );
    canvas.drawLine(
      Offset(size.x * 0.7, 0),
      Offset(size.x * 0.7, size.y),
      _ropePaint,
    );
  }
}
