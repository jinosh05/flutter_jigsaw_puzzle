import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_jigsaw_puzzle/src/level_selection/jigsaw_info.dart';

import '../collision/puzzle_collision_detection.dart';
import '../shape_type.dart';
import 'image_utils.dart';
import 'piece_component.dart';
import 'piece_group.dart';

class JigsawGame extends FlameGame with HasCollisionDetection {
  int gridSize = 6;
  List<List<PieceComponent>> pieces = [];
  List<PieceComponent> allPieces = [];
  ValueNotifier<List<PieceComponent>> unplacedPieces = ValueNotifier([]);
  List<Vector2> positions = [];
  double pieceSize = 0;
  JigsawInfo jigsawInfo;
  double _scale = 1.0;
  bool isAudioOn;
  Function win;
  double _imageWidth = 0;
  double _imageHeight = 0;
  double _widthPerBlock = 0;
  double _heightPerBlock = 0;
  Vector2 _puzzleOffset = Vector2.zero();

  JigsawGame(this.jigsawInfo, this.isAudioOn, this.win);

  @override
  Future<void> onLoad() async {
    collisionDetection = PuzzleCollisionDetection();
    var file = await DefaultCacheManager().getSingleFile(jigsawInfo.image);
    final bytes = await file.readAsBytes();
    Image image = await decodeImageFromBytes(bytes);

    gridSize = jigsawInfo.gridSize;
    _imageWidth = image.width.toDouble();
    _imageHeight = image.height.toDouble();

    // Scale the assembled puzzle to fit inside the square board area.
    _scale = ImageUtils.calculateScale(
      size.x * 0.78,
      size.y * 0.78,
      _imageWidth,
      _imageHeight,
    );

    _widthPerBlock = _imageWidth / gridSize;
    _heightPerBlock = _imageHeight / gridSize;
    pieceSize = min(_widthPerBlock, _heightPerBlock) / 4;
    _updatePuzzleOffset();

    for (var y = 0; y < gridSize; y++) {
      final tmpPieces = <PieceComponent>[];
      pieces.add(tmpPieces);
      for (var x = 0; x < gridSize; x++) {
        PieceComponent piece =
            getPiece(_widthPerBlock, _heightPerBlock, x, y, image);
        pieces[y].add(piece);
        allPieces.add(piece);
      }
    }

    // Initially, all pieces are in the list, not on the board
    allPieces.shuffle();
    unplacedPieces.value = List.from(allPieces);
  }

  void placePiece(PieceComponent piece) {
    if (unplacedPieces.value.contains(piece)) {
      // Position the piece in the center of the viewport initially
      piece.position = clampPosition(
        piece,
        Vector2(size.x / 2 - piece.size.x / 2, size.y / 2 - piece.size.y / 2),
      );
      add(piece);
      final updated = List<PieceComponent>.from(unplacedPieces.value)
        ..remove(piece);
      unplacedPieces.value = updated;
    }
  }

  bool showHint() {
    if (unplacedPieces.value.isEmpty) return false;

    PieceComponent? piece;
    Vector2? hintPosition;
    var bestNeighborCount = -1;

    for (final candidate in unplacedPieces.value) {
      final neighborCount = _placedNeighborCount(candidate);
      if (neighborCount > bestNeighborCount) {
        final candidatePosition = _positionFromPlacedNeighbor(candidate);
        if (candidatePosition != null) {
          piece = candidate;
          hintPosition = candidatePosition;
          bestNeighborCount = neighborCount;
        }
      }
    }

    piece ??= unplacedPieces.value.first;
    hintPosition ??= targetPositionFor(piece);
    piece.position = clampPosition(piece, hintPosition);
    add(piece);
    unplacedPieces.value = List<PieceComponent>.from(unplacedPieces.value)
      ..remove(piece);
    return true;
  }

  int _placedNeighborCount(PieceComponent piece) {
    return allPieces.where((other) {
      return children.contains(other) && _areNeighbors(piece, other);
    }).length;
  }

  bool _areNeighbors(PieceComponent first, PieceComponent second) {
    return (first.xSort == second.xSort &&
            (first.ySort - second.ySort).abs() == 1) ||
        (first.ySort == second.ySort &&
            (first.xSort - second.xSort).abs() == 1);
  }

  Vector2? _positionFromPlacedNeighbor(PieceComponent piece) {
    for (final neighbor in allPieces) {
      if (!children.contains(neighbor) || !_areNeighbors(piece, neighbor)) {
        continue;
      }

      if (piece.xSort == neighbor.xSort &&
          piece.ySort == neighbor.ySort + 1) {
        return neighbor.position +
            neighbor.bottomLeft.toVector2() -
            piece.topLeft.toVector2();
      }
      if (piece.xSort == neighbor.xSort &&
          piece.ySort == neighbor.ySort - 1) {
        return neighbor.position +
            neighbor.topLeft.toVector2() -
            piece.bottomLeft.toVector2();
      }
      if (piece.ySort == neighbor.ySort &&
          piece.xSort == neighbor.xSort + 1) {
        return neighbor.position +
            neighbor.topRight.toVector2() -
            piece.topLeft.toVector2();
      }
      if (piece.ySort == neighbor.ySort &&
          piece.xSort == neighbor.xSort - 1) {
        return neighbor.position +
            neighbor.topLeft.toVector2() -
            piece.topRight.toVector2();
      }
    }
    return null;
  }

  Vector2 targetPositionFor(PieceComponent piece) {
    final leftTab = piece.shape.leftTab != 0 ? pieceSize * _scale : 0.0;
    final topTab = piece.shape.topTab != 0 ? pieceSize * _scale : 0.0;
    return _puzzleOffset + Vector2(
          piece.xSort * _widthPerBlock * _scale - leftTab,
          piece.ySort * _heightPerBlock * _scale - topTab,
        );
  }

  Vector2 clampPosition(PieceComponent piece, Vector2 position) {
    final maxX = max(0.0, size.x - piece.size.x);
    final maxY = max(0.0, size.y - piece.size.y);
    return Vector2(
      position.x.clamp(0.0, maxX).toDouble(),
      position.y.clamp(0.0, maxY).toDouble(),
    );
  }

  void shuffleUnplacedPieces() {
    final shuffled = List<PieceComponent>.from(unplacedPieces.value)..shuffle();
    unplacedPieces.value = shuffled;
  }

  void returnAllPiecesToTray() {
    for (final piece in children.whereType<PieceComponent>().toList()) {
      piece.removeFromParent();
      piece.group = PieceGroup(piece);
      piece.priority = 0;
      piece.reactivateHitboxes();
    }
    unplacedPieces.value = List.from(allPieces);
  }

  Future<void> getResult(int num, bool added) async {
    if (num == gridSize * gridSize) {
      debugPrint("getResult win:$num");
      win();
      if (isAudioOn) {
        FlameAudio.play('won.wav');
      }
    } else {
      debugPrint("getResult isAudioOn:$isAudioOn");
      if (added && isAudioOn) {
        FlameAudio.play('click.wav');
      }
    }
  }

  // Helper to remove piece from list if it was already on board but then grouped
  void onPieceAttached(PieceComponent piece) {
    // This is called when a piece is successfully snapped
    // We already handle removal in placePiece, but this is a safety check
  }

  Future<Image> decodeImageFromBytes(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      debugPrint("image width:${img.width} image height:${img.height}:");
      completer.complete(img);
    });
    return completer.future;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (_imageWidth > 0 && _imageHeight > 0) {
      _updatePuzzleOffset();
    }
    debugPrint("onGameResize:$size");
  }

  void _updatePuzzleOffset() {
    _puzzleOffset = Vector2(
      max(0.0, (size.x - _imageWidth * _scale) / 2),
      max(0.0, (size.y - _imageHeight * _scale) / 2),
    );
  }

  PieceComponent getPiece(
      double widthPerBlock, double heightPerBlock, int x, int y, Image image) {
    Shape shape = _getShape(gridSize, x, y);
    double xAxis = widthPerBlock * x;
    double yAxis = heightPerBlock * y;
    //相对于扩大后图片的起点
    xAxis -= shape.leftTab != 0 ? pieceSize : 0;
    yAxis -= shape.topTab != 0 ? pieceSize : 0;
    final double widthPerBlockTemp = widthPerBlock +
        (shape.leftTab != 0 ? pieceSize : 0) +
        (shape.rightTab != 0 ? pieceSize : 0);
    final double heightPerBlockTemp = heightPerBlock +
        (shape.topTab != 0 ? pieceSize : 0) +
        (shape.bottomTab != 0 ? pieceSize : 0);

    final piece = PieceComponent(
      SpriteComponent(
          sprite: Sprite(
            image,
            srcPosition: Vector2(xAxis, yAxis),
            srcSize: Vector2(widthPerBlockTemp, heightPerBlockTemp),
          ),
          size:
              Vector2(widthPerBlockTemp * _scale, heightPerBlockTemp * _scale)),
      shape,
      pieceSize * _scale,
      x,
      y,
    );
    return piece;
  }

  ///
  /// 随机 1 凸起 2凹进去，0 平的
  Shape _getShape(int gridSize, int x, int y) {
    final int randomPosRow = math.Random().nextInt(2).isEven ? 1 : -1;
    final int randomPosCol = math.Random().nextInt(2).isEven ? 1 : -1;
    Shape shape = Shape();
    shape.bottomTab = y == gridSize - 1 ? 0 : randomPosCol;
    shape.leftTab = x == 0 ? 0 : -pieces[y][x - 1].shape.rightTab;
    shape.rightTab = x == gridSize - 1 ? 0 : randomPosRow;
    shape.topTab = y == 0 ? 0 : -pieces[y - 1][x].shape.bottomTab;
    return shape;
  }

  double pieceX = 0;
  double pieceY = 0;
  bool left = true;
  double positionOffsetX = -1;

  void generatePositionLeftRight(double widthPerBlock, double heightPerBlock) {
    int width = (widthPerBlock.toInt() + pieceSize * _scale * 2).toInt();
    int height = (heightPerBlock.toInt() + pieceSize * _scale * 2).toInt();
    pieceY = pieceY + height;
    if (positions.isEmpty) {
      pieceY = 0;
    }
    if (pieceY + height > size.y) {
      if (left) {
        pieceX = size.x - pieceX - width;
        left = false;
      } else {
        pieceX = size.x - pieceX;
        left = true;
      }
      pieceY = 0;
    }
    // print(" pieceX:$pieceX pieceY:$pieceY");
    positions.add(Vector2(pieceX, pieceY));
  }

  void generatePositionBottom(double widthPerBlock, double heightPerBlock) {
    int width = (widthPerBlock.toInt() + pieceSize * _scale * 2).toInt();
    int height = (heightPerBlock.toInt() + pieceSize * _scale * 2).toInt();
    pieceX = pieceX - width;
    if (positions.isEmpty) {
      pieceX = size.x - width;
      pieceY = size.y - height;
    }

    if (pieceX < 0) {
      if (positionOffsetX == -1) {
        positionOffsetX = -((pieceX + width) / 2.0);
      }
      pieceX = size.x - width;
      pieceY = pieceY - height;
    }
    // print(" pieceX:$pieceX pieceY:$pieceY");
    positions.add(Vector2(pieceX, pieceY));
  }
}
