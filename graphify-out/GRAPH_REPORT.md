# Graph Report - /home/jinosh/Program/Jigsaw/flutter_jigsaw_puzzle  (2026-07-02)

## Corpus Check
- 166 files · ~64,278 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 510 nodes · 532 edges · 39 communities detected
- Extraction: 97% EXTRACTED · 3% INFERRED · 0% AMBIGUOUS · INFERRED: 15 edges (avg confidence: 0.78)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_UI Widgets & Components|UI Widgets & Components]]
- [[_COMMUNITY_Puzzle Collision Detection|Puzzle Collision Detection]]
- [[_COMMUNITY_App Lifecycle & Main Menu|App Lifecycle & Main Menu]]
- [[_COMMUNITY_HTTPNetwork Engine (Dio)|HTTP/Network Engine (Dio)]]
- [[_COMMUNITY_Project Architecture & Docs|Project Architecture & Docs]]
- [[_COMMUNITY_Games Services & Shared UI|Games Services & Shared UI]]
- [[_COMMUNITY_Windows Platform Integration|Windows Platform Integration]]
- [[_COMMUNITY_App Lifecycle State Management|App Lifecycle State Management]]
- [[_COMMUNITY_Confetti Animation Widget|Confetti Animation Widget]]
- [[_COMMUNITY_Linux Build Configuration|Linux Build Configuration]]
- [[_COMMUNITY_HTTP Request Pipeline|HTTP Request Pipeline]]
- [[_COMMUNITY_Puzzle Collision Logic|Puzzle Collision Logic]]
- [[_COMMUNITY_Linux Application Entry Points|Linux Application Entry Points]]
- [[_COMMUNITY_Level Selection Screen|Level Selection Screen]]
- [[_COMMUNITY_Dio HTTP Client|Dio HTTP Client]]
- [[_COMMUNITY_macOS App Delegate|macOS App Delegate]]
- [[_COMMUNITY_Responsive Screen Layout|Responsive Screen Layout]]
- [[_COMMUNITY_macOS Plugin Registration|macOS Plugin Registration]]
- [[_COMMUNITY_Windows Entry Points|Windows Entry Points]]
- [[_COMMUNITY_macOS Unit Tests|macOS Unit Tests]]
- [[_COMMUNITY_App Icons & Assets|App Icons & Assets]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 74|Community 74]]
- [[_COMMUNITY_Community 75|Community 75]]

## God Nodes (most connected - your core abstractions)
1. `Real Jigsaw Puzzle` - 31 edges
2. `package:flutter/material.dart` - 17 edges
3. `package:provider/provider.dart` - 12 edges
4. `../style/palette.dart` - 8 edges
5. `package:flutter_screenutil/flutter_screenutil.dart` - 7 edges
6. `package:go_router/go_router.dart` - 7 edges
7. `dart:math` - 6 edges
8. `Create()` - 6 edges
9. `Destroy()` - 6 edges
10. `AppDelegate` - 5 edges

## Surprising Connections (you probably didn't know these)
- `Real Jigsaw Puzzle` --has_screenshot--> `Puzzle Screenshot In Progress`  [EXTRACTED]
  README.md → screenshot/real-puzzle01.webp
- `Real Jigsaw Puzzle` --has_screenshot--> `Puzzle Screenshot In Progress`  [EXTRACTED]
  README.md → screenshot/real-puzzle04.webp
- `Real Jigsaw Puzzle` --has_ui_asset--> `Restart Icon`  [EXTRACTED]
  README.md → assets/images/restart.png
- `Real Jigsaw Puzzle` --has_ui_asset--> `Settings Icon`  [EXTRACTED]
  README.md → assets/images/settings.png
- `Real Jigsaw Puzzle` --has_app_icon--> `App Launcher Icon`  [EXTRACTED]
  README.md → assets/images/ic_launcher.png

## Communities

### Community 0 - "UI Widgets & Components"
Cohesion: 0.04
Nodes (55): custom_name_dialog.dart, HttpException, toString, build, Container, JigsawGridItem, build, CachedNetworkImage (+47 more)

### Community 1 - "Puzzle Collision Detection"
Cohesion: 0.05
Nodes (40): ../collision/puzzle_collision_detection.dart, ../collision/PuzzleHitbox.dart, dart:async, dart:math, dart:ui, inactive, PuzzleHitbox, calculateScale (+32 more)

### Community 2 - "App Lifecycle & Main Menu"
Cohesion: 0.05
Nodes (33): AppLifecycleObserver, build, MainMenuScreen, MyApp, ScreenUtilInit, SettingsScreen, SpUtil, Score (+25 more)

### Community 3 - "HTTP/Network Engine (Dio)"
Cohesion: 0.06
Nodes (32): dart:convert, dart:io, checkRequest, DioEngine, download, get, post, setProxy (+24 more)

### Community 4 - "Project Architecture & Docs"
Cohesion: 0.07
Nodes (34): Google AdSense ca-pub-6775869677320164, Google Analytics 4 Measurement ID G-06FZDMBD56, Core Logic Layer (lib/), Platform Integration Layer, Presentation Widget Tree Layer, Claude Code Configuration, flutter analyze command, flutter build apk --release command (+26 more)

### Community 5 - "Games Services & Shared UI"
Cohesion: 0.06
Nodes (30): animated_hide_widget.dart, ../games_services/score.dart, build, IconButton, MainMenuScreen, Scaffold, Text, build (+22 more)

### Community 6 - "Windows Platform Integration"
Cohesion: 0.11
Nodes (19): RegisterPlugins(), FlutterWindow(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle() (+11 more)

### Community 7 - "App Lifecycle State Management"
Cohesion: 0.08
Nodes (25): AppLifecycleObserver, _AppLifecycleObserverState, build, didChangeAppLifecycleState, dispose, initState, attachLifecycleNotifier, attachSettings (+17 more)

### Community 8 - "Confetti Animation Widget"
Cohesion: 0.12
Nodes (16): dart:collection, build, Confetti, ConfettiPainter, _ConfettiState, CustomPaint, didUpdateWidget, dispose (+8 more)

### Community 9 - "Linux Build Configuration"
Cohesion: 0.12
Nodes (17): game_template binary name, Generated Plugin Build Rules, GIO System Dependency, GLIB System Dependency, GTK3 System Dependency, libflutter_linux_gtk.so shared library, flutter_windows.dll shared library, Linux Build Configuration (+9 more)

### Community 10 - "HTTP Request Pipeline"
Cohesion: 0.12
Nodes (15): addUrlToken, cancelRequest, catchError, checkRequest, download, get, getEngine, HttpEngine (+7 more)

### Community 11 - "Puzzle Collision Logic"
Cohesion: 0.15
Nodes (11): Function, handleCollision, handleCollisionEnd, handleCollisionStart, PuzzleCollisionDetection, typeCollision, PieceGroup, package:flame/geometry.dart (+3 more)

### Community 12 - "Linux Application Entry Points"
Cohesion: 0.18
Nodes (4): fl_register_plugins(), main(), my_application_activate(), my_application_new()

### Community 13 - "Level Selection Screen"
Cohesion: 0.22
Nodes (8): build, Container, initState, LoadingSelectionScreen, _LoadingSelectionScreenState, Scaffold, ../level_selection/jigsaw_info.dart, ../level_selection/piece_image.dart

### Community 14 - "Dio HTTP Client"
Cohesion: 0.29
Nodes (6): dio_engine.dart, DioClient, get, getInstance, post, package:flutter_jigsaw_puzzle/src/http/http_engine.dart

### Community 15 - "macOS App Delegate"
Cohesion: 0.33
Nodes (2): FlutterAppDelegate, AppDelegate

### Community 16 - "Responsive Screen Layout"
Cohesion: 0.33
Nodes (5): build, Column, LayoutBuilder, ResponsiveScreen, Row

### Community 17 - "macOS Plugin Registration"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 18 - "Windows Entry Points"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 19 - "macOS Unit Tests"
Cohesion: 0.4
Nodes (2): RunnerTests, XCTestCase

### Community 20 - "App Icons & Assets"
Cohesion: 0.4
Nodes (5): Android Launcher Icon, General App Icon, iOS App Icon, macOS App Icon, Web Icons

### Community 21 - "Community 21"
Cohesion: 0.5
Nodes (2): handle_new_rx_page(), Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.

### Community 22 - "Community 22"
Cohesion: 0.67
Nodes (2): GeneratedPluginRegistrant, -registerWithRegistry

### Community 23 - "Community 23"
Cohesion: 0.67
Nodes (2): Song, toString

### Community 24 - "Community 24"
Cohesion: 0.67
Nodes (1): GeneratedPluginRegistrant

### Community 25 - "Community 25"
Cohesion: 1.0
Nodes (1): soundTypeToVolume

### Community 26 - "Community 26"
Cohesion: 1.0
Nodes (1): JigsawCategory

### Community 27 - "Community 27"
Cohesion: 1.0
Nodes (1): JigsawInfo

### Community 28 - "Community 28"
Cohesion: 1.0
Nodes (1): Shape

### Community 29 - "Community 29"
Cohesion: 1.0
Nodes (1): Version

### Community 30 - "Community 30"
Cohesion: 1.0
Nodes (1): SettingsPersistence

### Community 41 - "Community 41"
Cohesion: 1.0
Nodes (1): MainActivity

### Community 42 - "Community 42"
Cohesion: 1.0
Nodes (2): Click Sound Effect (duplicate in sfx), Click Sound Effect

### Community 70 - "Community 70"
Cohesion: 1.0
Nodes (1): Music Attribution by Mr Smith

### Community 71 - "Community 71"
Cohesion: 1.0
Nodes (1): iOS Launch Screen Instructions

### Community 72 - "Community 72"
Cohesion: 1.0
Nodes (1): Web Entry Point HTML

### Community 73 - "Community 73"
Cohesion: 1.0
Nodes (1): Win Sound Effect

### Community 74 - "Community 74"
Cohesion: 1.0
Nodes (1): Background Music (Mr_Smith-Azul)

### Community 75 - "Community 75"
Cohesion: 1.0
Nodes (1): iOS Launch Image

## Knowledge Gaps
- **296 isolated node(s):** `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MyApp`, `SpUtil`, `MainMenuScreen` (+291 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **Thin community `macOS App Delegate`** (6 nodes): `FlutterAppDelegate`, `AppDelegate.swift`, `AppDelegate.swift`, `AppDelegate`, `.application()`, `.applicationShouldTerminateAfterLastWindowClosed()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `macOS Unit Tests`** (5 nodes): `RunnerTests.swift`, `RunnerTests.swift`, `RunnerTests`, `.testExample()`, `XCTestCase`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 21`** (4 nodes): `handle_new_rx_page()`, `__lldb_init_module()`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `flutter_lldb_helper.py`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 22`** (3 nodes): `GeneratedPluginRegistrant.m`, `GeneratedPluginRegistrant`, `-registerWithRegistry`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 23`** (3 nodes): `Song`, `toString`, `songs.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 24`** (3 nodes): `GeneratedPluginRegistrant.java`, `GeneratedPluginRegistrant`, `.registerWith()`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 25`** (2 nodes): `soundTypeToVolume`, `sounds.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 26`** (2 nodes): `JigsawCategory`, `jigsaw_category.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 27`** (2 nodes): `JigsawInfo`, `jigsaw_info.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 28`** (2 nodes): `Shape`, `shape_type.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 29`** (2 nodes): `Version`, `version.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 30`** (2 nodes): `SettingsPersistence`, `settings_persistence.dart`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 41`** (2 nodes): `MainActivity.kt`, `MainActivity`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 42`** (2 nodes): `Click Sound Effect (duplicate in sfx)`, `Click Sound Effect`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 70`** (1 nodes): `Music Attribution by Mr Smith`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 71`** (1 nodes): `iOS Launch Screen Instructions`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 72`** (1 nodes): `Web Entry Point HTML`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 73`** (1 nodes): `Win Sound Effect`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 74`** (1 nodes): `Background Music (Mr_Smith-Azul)`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.
- **Thin community `Community 75`** (1 nodes): `iOS Launch Image`
  Too small to be a meaningful cluster - may be noise or needs more connections extracted.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `UI Widgets & Components` to `Puzzle Collision Detection`, `App Lifecycle & Main Menu`, `HTTP/Network Engine (Dio)`, `Games Services & Shared UI`, `Level Selection Screen`, `Responsive Screen Layout`?**
  _High betweenness centrality (0.113) - this node is a cross-community bridge._
- **Why does `dart:math` connect `Puzzle Collision Detection` to `Confetti Animation Widget`, `HTTP/Network Engine (Dio)`, `Level Selection Screen`, `App Lifecycle State Management`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._
- **Why does `package:provider/provider.dart` connect `UI Widgets & Components` to `App Lifecycle & Main Menu`, `HTTP/Network Engine (Dio)`, `Games Services & Shared UI`, `App Lifecycle State Management`, `Level Selection Screen`?**
  _High betweenness centrality (0.047) - this node is a cross-community bridge._
- **What connects `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `-registerWithRegistry`, `MyApp` to the rest of the system?**
  _296 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `UI Widgets & Components` be split into smaller, more focused modules?**
  _Cohesion score 0.04 - nodes in this community are weakly interconnected._
- **Should `Puzzle Collision Detection` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `App Lifecycle & Main Menu` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._