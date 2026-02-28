import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_manager.dart';

class Track extends PositionComponent with HasGameRef<CarRacingGame> {
  final double speed = 200.0;
  double lineOffset = 0.0;
  double treeOffset = 0.0;
  final Paint asphaltPaint = Paint()..color = Colors.grey[800]!;
  final Paint linePaint = Paint()..color = Colors.white;
  final Paint grassPaint = Paint()..color = Colors.green[700]!;
  final Paint treeTrunkPaint = Paint()..color = Colors.brown[700]!;
  final Paint treeLeavesPaint = Paint()..color = Colors.green[900]!;
  final double treeSpacing = 200.0;

  @override
  void render(Canvas canvas) {
    // Draw asphalt
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      asphaltPaint,
    );

    // Draw grass shoulders
    double grassWidth = 40.0;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, grassWidth, gameRef.size.y),
      grassPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(gameRef.size.x - grassWidth, 0, grassWidth, gameRef.size.y),
      grassPaint,
    );
    // Draw center dashed lines
    double dashHeight = 40;
    double gapHeight = 40;
    double centerX = gameRef.size.x / 2;
    double totalUnit = dashHeight + gapHeight;

    for (
      double y = lineOffset - totalUnit * 2;
      y < gameRef.size.y + totalUnit;
      y += totalUnit
    ) {
      canvas.drawRect(Rect.fromLTWH(centerX - 5, y, 10, dashHeight), linePaint);
    }

    // Draw trees
    for (
      double y = treeOffset - treeSpacing * 2;
      y < gameRef.size.y + treeSpacing;
      y += treeSpacing
    ) {
      _drawTree(canvas, 20.0, y);
      _drawTree(canvas, gameRef.size.x - 20.0, y);
    }
  }

  void _drawTree(Canvas canvas, double x, double y) {
    // Tree trunk
    canvas.drawRect(Rect.fromLTWH(x - 5, y - 10, 10, 20), treeTrunkPaint);
    // Tree leaves
    canvas.drawCircle(Offset(x, y - 15), 18, treeLeavesPaint);
    canvas.drawCircle(Offset(x, y - 30), 12, treeLeavesPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.isPlaying) return;

    lineOffset += speed * dt;
    double totalUnit = 80.0; // dashHeight + gapHeight
    if (lineOffset >= totalUnit) {
      lineOffset -= totalUnit;
    }

    treeOffset += speed * dt;
    if (treeOffset >= treeSpacing) {
      treeOffset -= treeSpacing;
    }
  }
}
