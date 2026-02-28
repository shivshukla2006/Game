import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame_audio/flame_audio.dart';
import 'game_manager.dart';
import 'opponent_car.dart';

class PlayerCar extends PositionComponent
    with HasGameRef<CarRacingGame>, CollisionCallbacks, KeyboardHandler {
  final JoystickComponent joystick;
  double maxSpeed = 300.0;
  Vector2 keyboardVelocity = Vector2.zero();
  bool isBoosting = false;
  bool _wasBoosting = false;

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
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    keyboardVelocity = Vector2.zero();

    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      keyboardVelocity.y = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      keyboardVelocity.y = 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      keyboardVelocity.x = -1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      keyboardVelocity.x = 1;
    }

    if (keyboardVelocity.length > 0) {
      keyboardVelocity.normalize();
    }

    isBoosting =
        keysPressed.contains(LogicalKeyboardKey.shiftLeft) ||
        keysPressed.contains(LogicalKeyboardKey.shiftRight);

    if (isBoosting && !_wasBoosting) {
      FlameAudio.play('exhaust.wav', volume: 0.5);
    }
    _wasBoosting = isBoosting;

    return true;
  }

  @override
  void update(double dt) {
    if (!gameRef.isPlaying) return;

    super.update(dt);

    double currentSpeed = isBoosting ? maxSpeed * 1.8 : maxSpeed;

    // Combine joystick and keyboard input
    Vector2 finalVelocity = Vector2.zero();
    if (joystick.direction != JoystickDirection.idle) {
      finalVelocity.add(joystick.relativeDelta);
    }
    finalVelocity.add(keyboardVelocity);

    if (finalVelocity.length > 1.0) {
      finalVelocity.normalize();
    }

    position.add(finalVelocity * currentSpeed * dt);

    // Keep car within screen bounds, considering the 40px grass margin
    position.x = position.x.clamp(
      40.0 + size.x / 2,
      gameRef.size.x - 40.0 - size.x / 2,
    );
    position.y = position.y.clamp(size.y / 2, gameRef.size.y - size.y / 2);
  }

  @override
  void render(Canvas canvas) {
    if (isBoosting) {
      // Draw exhaust flames
      final flamePaint1 = Paint()..color = Colors.orange;
      final flamePaint2 = Paint()..color = Colors.yellow;

      // Left exhaust
      canvas.drawCircle(Offset(size.x * 0.25, size.y + 10), 8, flamePaint1);
      canvas.drawCircle(Offset(size.x * 0.25, size.y + 15), 5, flamePaint2);

      // Right exhaust
      canvas.drawCircle(Offset(size.x * 0.75, size.y + 10), 8, flamePaint1);
      canvas.drawCircle(Offset(size.x * 0.75, size.y + 15), 5, flamePaint2);
    }

    OpponentCar.drawBMW(canvas, size, Colors.blue);
  }
}
