# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Workflow

The project is a Flutter application utilizing the Flame game engine. The standard development lifecycle uses the Flutter CLI from the root directory (`flutter_jigsaw_puzzle`).

### Essential Commands
*   **Run/Develop:** `flutter run` — Launches the app for interactive debugging and testing of state changes in a live environment.
*   **Testing (Unit/Widget):** `flutter test` — Executes all defined unit and widget tests. For targeted testing, utilize IDE-specific or CLI filtering capabilities targeting specific files or widgets within the `lib/` directory.
*   **Code Analysis:** `flutter analyze` — Runs static analysis to catch type errors, unused code, and potential lints.
*   **Build Release APK:** `flutter build apk --release` — Generates a production-ready Android artifact.
*   **Build Web:** `flutter build web` — Creates the necessary assets for deployment on a web server.

### Architecture Pattern: Game State Management (Flame/Flutter)
The application follows standard Flutter separation of concerns, overlaid with Flame's game loop requirements.

1.  **Core Logic (`lib/`):** This is the source of truth for all puzzle mechanics, state management, and game logic. Due to the nature of a real-time interactive game, state changes typically flow through:
    *   A **Puzzle Model/Service Class**: Holds the abstract rules (e.g., which piece belongs where) independent of Flutter widgets.
    *   **Flame `Game` Widget**: Orchestrates the drawing loop and handles physics/input events, calling methods on the Puzzle Model.
2.  **Presentation (`widget tree`):** Standard Flutter widgets are used for non-gameplay UI elements (menus, splash screens). These communicate state changes upward to the core logic.
3.  **Platform Integration:** Changes requiring native access must be scoped:
    *   `android/`: Handles Android manifest, permissions, and platform services hooks (`Activity`).
    *   `ios/`: Manages iOS-specific dependencies and project settings (`Info.plist`, `Podfile`).

**Conclusion for development:** All non-UI logic changes should be implemented first in a service layer within `lib/`. Changes to the UI or platform integration should then *consume* that updated state, minimizing risk by isolating game rules from presentation.