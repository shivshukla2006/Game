import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_manager.dart';
import 'package:flame/collisions.dart';

class OpponentCar extends PositionComponent with HasGameRef<CarRacingGame> {
  final double speed;
  final Color carColor;

  OpponentCar({required this.speed, this.carColor = Colors.red})
    : super(size: Vector2(60, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!gameRef.isPlaying) return;
    super.update(dt);

    position.y += speed * dt;

    // Remove if off-screen
    if (position.y > gameRef.size.y + size.y) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    drawBMW(canvas, size, carColor);
  }

  static void drawBMW(Canvas canvas, Vector2 size, Color primaryColor) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Shadow
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(5, 5, size.x, size.y),
        const Radius.circular(10),
      ),
      Paint()
        ..color = Colors.black.withOpacity(0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Car Body
    paint.color = primaryColor;
    final bodyRect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, const Radius.circular(12)),
      paint,
    );

    // Roof / Windshields
    paint.color = Colors.black87;
    final roofRect = Rect.fromLTWH(
      size.x * 0.1,
      size.y * 0.25,
      size.x * 0.8,
      size.y * 0.45,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(roofRect, const Radius.circular(8)),
      paint,
    );

    // Headlights
    paint.color = Colors.white.withOpacity(0.9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x * 0.1, size.y * 0.05, size.x * 0.2, size.y * 0.1),
        const Radius.circular(3),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x * 0.7, size.y * 0.05, size.x * 0.2, size.y * 0.1),
        const Radius.circular(3),
      ),
      paint,
    );

    // Taillights
    paint.color = Colors.redAccent;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.x * 0.1, size.y * 0.9, size.x * 0.25, size.y * 0.05),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.x * 0.65,
          size.y * 0.9,
          size.x * 0.25,
          size.y * 0.05,
        ),
        const Radius.circular(2),
      ),
      paint,
    );

    // BMW Grille
    paint.color = Colors.black87;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.x * 0.4,
          size.y * 0.02,
          size.x * 0.08,
          size.y * 0.04,
        ),
        const Radius.circular(2),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.x * 0.52,
          size.y * 0.02,
          size.x * 0.08,
          size.y * 0.04,
        ),
        const Radius.circular(2),
      ),
      paint,
    );

    // BMW Logo (simplified)
    paint.color = Colors.white;
    canvas.drawCircle(Offset(size.x * 0.5, size.y * 0.1), 3, paint);
    paint.color = Colors.blue;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.x * 0.5, size.y * 0.1), radius: 3),
      0,
      3.14159 / 2,
      true,
      paint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.x * 0.5, size.y * 0.1), radius: 3),
      3.14159,
      3.14159 / 2,
      true,
      paint,
    );
  }
}
