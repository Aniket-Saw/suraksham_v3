import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// A first aid kit placed near the house by the user.
class KitComponent extends PositionComponent {
  final Paint _boxPaint = Paint()..color = const Color(0xFFE0E0E0);
  final Paint _crossPaint = Paint()
    ..color = const Color(0xFFE53935)
    ..strokeWidth = 4
    ..style = PaintingStyle.fill;

  KitComponent({required super.position, required super.size})
    : super(priority: 10, anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Kit box
    final box = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(4),
    );
    canvas.drawRRect(box, _boxPaint);

    // Red cross symbol
    final cx = size.x / 2;
    final cy = size.y / 2;
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy), width: size.x * 0.5, height: 5),
      _crossPaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(cx, cy), width: 5, height: size.y * 0.5),
      _crossPaint,
    );
  }
}
