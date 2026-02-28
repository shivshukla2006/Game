import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game_manager.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: GameApp()));
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late CarRacingGame _game;

  @override
  void initState() {
    super.initState();
    _game = CarRacingGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: _game,
        initialActiveOverlays: const ['menu'],
        overlayBuilderMap: {
          'menu': (BuildContext context, CarRacingGame game) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.blueGrey.shade900.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 50.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 60,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'HIGHWAY',
                      style: TextStyle(
                        fontSize: 52,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 6.0,
                        shadows: [
                          Shadow(color: Colors.blueAccent, blurRadius: 10),
                        ],
                      ),
                    ),
                    const Text(
                      'RACER',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      onPressed: () => game.startGame(),
                      child: const Text(
                        'START ENGINES',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          'hud': (BuildContext context, CarRacingGame game) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: game.scoreNotifier,
                      builder: (context, score, child) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.speed, color: Colors.blueAccent),
                              const SizedBox(width: 10),
                              Text(
                                '$score M',
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.pause_circle_filled,
                        color: Colors.white70,
                        size: 40,
                      ),
                      onPressed: () => game.gameOver(),
                    ),
                  ],
                ),
              ),
            );
          },
          'game_over': (BuildContext context, CarRacingGame game) {
            return Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.redAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50.0,
                  vertical: 40.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'CRASHED!',
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<int>(
                      valueListenable: game.scoreNotifier,
                      builder: (context, score, child) {
                        return Text(
                          'DISTANCE: $score M',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text(
                        'TRY AGAIN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () => game.startGame(),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        game.overlays.remove('game_over');
                        game.overlays.add('menu');
                      },
                      child: const Text(
                        'MAIN MENU',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        },
      ),
    );
  }
}
