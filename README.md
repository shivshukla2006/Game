# Highway Racer

A 2D endless car racing game built with Flutter and the Flame Engine. Navigate the highway, dodge obstacles, and drive as far as you can to get the highest score!

## Features
- **Endless Racing:** Drive continuously while avoiding crashes.
- **Score System:** Tracks the distance you travel.
- **Flame Engine integration:** Smooth 2D gameplay, physics, and rendering.
- **Interactive UI:** Custom main menu, real-time HUD, and Game Over screens.

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version ^3.11.0 or higher)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd Game
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure
- `lib/main.dart`: Application entry point, sets up the Flame `GameWidget` and UI overlays.
- `lib/game_manager.dart`: Core game loop, Flame component management, and score tracking.
- `lib/car_controller.dart`: Player movement and opponent car spawning/logic.
- `lib/track.dart`: Infinite scrolling background and track rendering.

## Built With
- [Flutter](https://flutter.dev/) - UI toolkit for building natively compiled applications.
- [Flame](https://flame-engine.org/) - A minimalist Flutter game engine.
