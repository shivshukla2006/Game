import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'game_manager.dart';
import 'opponent_car.dart';

class PlayerCar extends PositionComponent
    with HasGameRef<CarRacingGame>, CollisionCallbacks {
  final JoystickComponent joystick;
  double maxSpeed = 300.0;

  PlayerCar(this.joystick)
    : super(size: Vector2(60, 100), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is OpponentCar && gameRef.isPlaying) {
      gameRef.gameOver();
    }
  }

  @override
  void update(double dt) {
    if (!gameRef.isPlaying) return;

    super.update(dt);

    if (joystick.direction != JoystickDirection.idle) {
      position.add(joystick.relativeDelta * maxSpeed * dt);

      // Keep car within screen bounds, considering the 40px grass margin
      position.x = position.x.clamp(
        40.0 + size.x / 2,
        gameRef.size.x - 40.0 - size.x / 2,
      );
      position.y = position.y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
    }
  }

  @override
  void render(Canvas canvas) {
    OpponentCar.drawBMW(canvas, size, Colors.blue);
  }
}
