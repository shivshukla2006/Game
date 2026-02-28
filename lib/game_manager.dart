import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flame/input.dart';
import 'car_controller.dart';
import 'track.dart';
import 'opponent_car.dart';

class CarRacingGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late PlayerCar player;
  late Track backgroundTrack;
  late JoystickComponent joystick;

  bool isPlaying = false;
  double score = 0;
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  double _spawnTimer = 0;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    backgroundTrack = Track();
    add(backgroundTrack);

    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();

    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 60, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    player = PlayerCar(joystick);
    player.position = Vector2(size.x / 2, size.y - 100);

    add(player);
    add(joystick);
  }

  void startGame() {
    isPlaying = true;
    score = 0;
    scoreNotifier.value = 0;
    player.position = Vector2(size.x / 2, size.y - 100);

    // Remove existing opponents
    children.whereType<OpponentCar>().forEach((car) => car.removeFromParent());
    _spawnTimer = 0;

    overlays.remove('menu');
    overlays.remove('game_over');
    overlays.add('hud');
  }

  void gameOver() {
    isPlaying = false;
    overlays.remove('hud');
    overlays.add('game_over');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPlaying) {
      score += 10 * dt;
      if (score.toInt() > scoreNotifier.value) {
        scoreNotifier.value = score.toInt();
      }

      _spawnTimer += dt;
      double spawnInterval = max(0.5, 1.5 - (score / 2000));
      if (_spawnTimer >= spawnInterval) {
        _spawnTimer = 0;
        double speed = 150 + min(400, score * 0.2);

        // Ensure cars spawn within readable bounds (padding of 40 on each side)
        double minX = 40.0;
        double maxX = size.x - 40.0;
        double x = minX + _random.nextDouble() * (maxX - minX);

        Color color = [
          Colors.red,
          Colors.green,
          Colors.orange,
          Colors.purple,
        ][_random.nextInt(4)];

        add(
          OpponentCar(speed: speed, carColor: color)
            ..position = Vector2(x, -100),
        );
      }
    }
  }
}
