import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// A draggable spawn area for emergency items (sandbags or kits).
/// When the user drags from this area, a ghost item follows their finger
/// and is placed on drop.
class ItemSpawnArea extends PositionComponent with DragCallbacks {
  final String label;
  final Color iconColor;
  final String itemIcon;
  final int maxItems;
  final void Function(Vector2 dropPosition) onDragComplete;

  int _itemsUsed = 0;
  bool _isDragging = false;
  Vector2? _dragPosition;

  final Paint _bgPaint = Paint();
  final Paint _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  late final Paint _ghostPaint;

  ItemSpawnArea({
    required super.position,
    required super.size,
    required this.label,
    required this.iconColor,
    required this.itemIcon,
    required this.maxItems,
    required this.onDragComplete,
  }) : super(priority: 20) {
    _bgPaint.color = iconColor.withValues(alpha: 0.15);
    _borderPaint.color = iconColor.withValues(alpha: 0.5);
    _ghostPaint = Paint()..color = iconColor.withValues(alpha: 0.6);
  }

  bool get hasItemsLeft => _itemsUsed < maxItems;

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (!hasItemsLeft) return;
    _isDragging = true;
    _dragPosition = event.canvasPosition;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (!_isDragging) return;
    _dragPosition = event.canvasStartPosition;
  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (!_isDragging) return;
    _isDragging = false;

    if (_dragPosition != null) {
      onDragComplete(_dragPosition!);
      _itemsUsed++;
    }
    _dragPosition = null;
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _isDragging = false;
    _dragPosition = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Background
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    canvas.drawRRect(rect, _bgPaint);
    canvas.drawRRect(rect, _borderPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$label\n${maxItems - _itemsUsed} left',
        style: TextStyle(
          color: iconColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: size.x);
    textPainter.paint(
      canvas,
      Offset((size.x - textPainter.width) / 2, size.y * 0.55),
    );

    // Icon representation
    final iconPainter = TextPainter(
      text: TextSpan(text: itemIcon, style: const TextStyle(fontSize: 28)),
      textDirection: TextDirection.ltr,
    );
    iconPainter.layout();
    iconPainter.paint(canvas, Offset((size.x - iconPainter.width) / 2, 8));

    // Draw ghost item at drag position
    if (_isDragging && _dragPosition != null) {
      final localDrag = _dragPosition! - absolutePosition;
      canvas.drawCircle(Offset(localDrag.x, localDrag.y), 15, _ghostPaint);
    }
  }
}
