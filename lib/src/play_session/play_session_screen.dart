// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'dart:ui' as ui;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jigsaw_puzzle/src/level_selection/jigsaw_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../games_services/score.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import 'jigsaw/jigsaw_game.dart';
import 'jigsaw/piece_component.dart';

class PlaySessionScreen extends StatefulWidget {
  final JigsawInfo level;

  const PlaySessionScreen(this.level, {super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  final bool _duringCelebration = false;
  int hintsRemaining = 3;
  bool showImagePeek = false;
  bool hasUsedImagePeek = false;
  bool isWatchingAd = false;
  late JigsawGame _game;
  late DateTime _startOfPlay;
  final TransformationController _transformController =
      TransformationController();
  final GlobalKey _boardViewportKey = GlobalKey();
  final ScrollController _piecesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startOfPlay = DateTime.now();
    final settingsController = context.read<SettingsController>();
    _game = _createGame(settingsController);
  }

  JigsawGame _createGame(SettingsController settingsController) {
    return JigsawGame(
      widget.level,
      settingsController.soundsOn.value && !settingsController.muted.value,
      playerWon,
    );
  }

  @override
  void dispose() {
    _transformController.dispose();
    _piecesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return IgnorePointer(
      ignoring: _duringCelebration || isWatchingAd,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: palette.backgroundMain,
            appBar: AppBar(
              elevation: 0,
              leading: BackButton(
                color: palette.textColor,
                onPressed: () => Navigator.pop(context),
              ),
              centerTitle: true,
              backgroundColor: palette.backgroundMain,
              title: Text(
                'Real Puzzle',
                style: TextStyle(
                  fontSize: 28.sp,
                  color: palette.textColor,
                ),
              ),
              actions: [
                _buildHintButton(palette),
                IconButton(
                  tooltip: 'Reset puzzle',
                  icon: Icon(Icons.restart_alt, color: palette.textColor),
                  onPressed: showReset,
                ),
                SizedBox(width: 8.w),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const padding = 6.0;
                      final frameSize = max(
                        0.0,
                        min(
                          constraints.maxWidth - padding * 2,
                          constraints.maxHeight - padding * 2,
                        ),
                      );
                      final boardSize = max(0.0, frameSize - 4);

                      return Center(
                        child: Container(
                          width: frameSize,
                          height: frameSize,
                          margin: const EdgeInsets.all(padding),
                          decoration: BoxDecoration(
                            color: palette.backgroundMain,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: palette.textColor.withOpacity(0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: palette.textColor.withOpacity(0.12),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            key: _boardViewportKey,
                            borderRadius: BorderRadius.circular(14.r),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                InteractiveViewer(
                                  transformationController:
                                      _transformController,
                                  boundaryMargin: EdgeInsets.zero,
                                  clipBehavior: Clip.hardEdge,
                                  minScale: 1.0,
                                  maxScale: 3.0,
                                  child: SizedBox(
                                    width: boardSize,
                                    height: boardSize,
                                    child: GameWidget(
                                      loadingBuilder: (context) => Center(
                                        child: CircularProgressIndicator(
                                          color: palette.textColor,
                                        ),
                                      ),
                                      game: _game,
                                      backgroundBuilder: (context) =>
                                          Container(
                                        color: palette.backgroundMain,
                                      ),
                                    ),
                                  ),
                                ),
                                if (showImagePeek)
                                  _buildPuzzleImageOverlay(
                                    palette: palette,
                                    opacity: 1.0,
                                  ),
                                Positioned(
                                  left: 8.w,
                                  bottom: 8.h,
                                  child: _buildEyeButton(palette),
                                ),
                                Positioned(
                                  right: 8.w,
                                  bottom: 8.h,
                                  child: _buildZoomControls(palette),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildPieceList(palette),
              ],
            ),
          ),
          if (isWatchingAd)
            ColoredBox(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: palette.btnOkColor),
                    SizedBox(height: 16.h),
                    Text(
                      'Watching ad...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPuzzleImageOverlay({
    required Palette palette,
    required double opacity,
  }) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: CachedNetworkImage(
            imageUrl: widget.level.image,
            fit: BoxFit.contain,
            placeholder: (_, __) => Center(
              child: CircularProgressIndicator(color: palette.textColor),
            ),
            errorWidget: (_, __, ___) => Center(
              child: Icon(Icons.broken_image, color: palette.textColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHintButton(Palette palette) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.lightbulb_outline, color: palette.tabSelectColor),
          onPressed: _useHint,
        ),
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: palette.btnOkColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$hintsRemaining',
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEyeButton(Palette palette) {
    return Material(
      color: palette.backgroundMain.withOpacity(0.9),
      elevation: 4,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: hasUsedImagePeek ? null : _peekFullImage,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Icon(
            Icons.visibility,
            color: hasUsedImagePeek
                ? palette.textColor.withOpacity(0.3)
                : palette.textColor,
            size: 28.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildZoomControls(Palette palette) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildZoomButton(
          palette: palette,
          icon: Icons.add,
          onPressed: () => _zoomBy(1.25),
        ),
        SizedBox(height: 8.h),
        _buildZoomButton(
          palette: palette,
          icon: Icons.remove,
          onPressed: () => _zoomBy(0.8),
        ),
      ],
    );
  }

  Widget _buildZoomButton({
    required Palette palette,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: palette.backgroundMain.withOpacity(0.9),
      elevation: 4,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Icon(icon, color: palette.textColor, size: 28.sp),
        ),
      ),
    );
  }

  void _zoomBy(double factor) {
    final matrix = _transformController.value.clone();
    final currentScale = matrix.getMaxScaleOnAxis();
    final newScale = (currentScale * factor).clamp(1.0, 3.0).toDouble();
    if (newScale == currentScale) return;

    final scaleChange = newScale / currentScale;
    final viewportSize = _boardViewportKey.currentContext?.size;
    if (viewportSize == null) return;

    final center = Offset(viewportSize.width / 2, viewportSize.height / 2);
    matrix.translate(center.dx, center.dy);
    matrix.scale(scaleChange);
    matrix.translate(-center.dx, -center.dy);
    _transformController.value = matrix;
  }

  Widget _buildPieceList(Palette palette) {
    return ValueListenableBuilder<List<PieceComponent>>(
      valueListenable: _game.unplacedPieces,
      builder: (context, pieces, child) {
        return Container(
          margin: EdgeInsets.fromLTRB(8.w, 0, 8.w, 8.h),
          decoration: BoxDecoration(
            color: palette.tabUnSelectColor.withOpacity(0.35),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: palette.textColor.withOpacity(0.15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                child: Row(
                  children: [
                    Text(
                      'Pieces (${pieces.length})',
                      style: TextStyle(
                        color: palette.textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Shuffle pieces',
                      icon: Icon(Icons.shuffle, color: palette.textColor),
                      onPressed: pieces.isEmpty
                          ? null
                          : () => _game.shuffleUnplacedPieces(),
                    ),
                  ],
                ),
              ),
              if (pieces.isEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Text(
                    'All pieces are on the board',
                    style: TextStyle(
                      color: palette.textColor.withOpacity(0.6),
                      fontSize: 12.sp,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 86.h,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: Scrollbar(
                      controller: _piecesScrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _piecesScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
                        itemCount: pieces.length,
                        itemBuilder: (context, index) {
                          final piece = pieces[index];
                          return GestureDetector(
                            onTap: () => _game.placePiece(piece),
                            child: Container(
                              width: 78.h,
                              margin: EdgeInsets.only(right: 8.w),
                              decoration: BoxDecoration(
                                color: palette.backgroundMain.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: palette.textColor.withOpacity(0.2),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: _PiecePreview(piece: piece),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _useHint() {
    if (hintsRemaining > 0) {
      if (_game.showHint()) {
        setState(() => hintsRemaining--);
      }
      return;
    }
    _showRewardAdDialog();
  }

  void _peekFullImage() {
    if (hasUsedImagePeek) return;

    setState(() {
      hasUsedImagePeek = true;
      showImagePeek = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => showImagePeek = false);
      }
    });
  }

  void _showRewardAdDialog() {
    final palette = context.read<Palette>();
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      dialogBackgroundColor: palette.backgroundMain,
      btnOkColor: palette.btnOkColor,
      title: 'Out of Hints!',
      desc: 'Watch a quick video to get 3 free hints?',
      btnCancelText: 'No thanks',
      btnCancelOnPress: () {},
      btnOkText: 'Watch Ad',
      btnOkOnPress: () {
        setState(() => isWatchingAd = true);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              hintsRemaining = 3;
              isWatchingAd = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Received 3 free hints!'),
                backgroundColor: palette.btnOkColor,
              ),
            );
          }
        });
      },
    ).show();
  }

  void showReset() {
    final palette = context.read<Palette>();
    AwesomeDialog(
      width: 400.h,
      dialogBackgroundColor: palette.backgroundMain,
      btnOkColor: palette.btnOkColor,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.noHeader,
      headerAnimationLoop: false,
      title: 'Reset pieces?',
      btnOkText: 'Reset',
      btnCancelText: 'Cancel',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        final settingsController = context.read<SettingsController>();
        setState(() {
          _game = _createGame(settingsController);
          hintsRemaining = 3;
          showImagePeek = false;
          hasUsedImagePeek = false;
          _transformController.value = Matrix4.identity();
        });
      },
    ).show();
  }

  Future<void> playerWon() async {
    final score = Score(
      DateTime.now().difference(_startOfPlay),
    );
    AwesomeDialog(
      width: 400.h,
      bodyHeaderDistance: 0,
      padding: const EdgeInsets.all(0),
      dismissOnTouchOutside: false,
      context: context,
      animType: AnimType.scale,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      body: SizedBox(
        width: 400.h,
        height: 0.3.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 0.2.sh,
              child: Center(child: Lottie.asset('assets/lottie/win.json')),
            ),
            Text(
              'Time: ${score.formattedTime}',
              style: TextStyle(fontSize: 16.sp, color: Palette().textColor),
            )
          ],
        ),
      ),
      dialogBackgroundColor: Palette().backgroundMain,
      btnOkColor: Palette().btnOkColor,
      btnOkText: 'Continue',
      btnOkOnPress: () {
        GoRouter.of(context).go('/play');
      },
    ).show();
  }
}

class _PiecePreview extends StatelessWidget {
  final PieceComponent piece;

  const _PiecePreview({required this.piece});

  @override
  Widget build(BuildContext context) {
    final sprite = piece.sprite?.sprite;
    if (sprite == null) {
      return const Icon(Icons.extension, color: Colors.white24);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _PiecePainter(
            image: sprite.image,
            src: Rect.fromLTWH(
              sprite.srcPosition.x,
              sprite.srcPosition.y,
              sprite.srcSize.x,
              sprite.srcSize.y,
            ),
          ),
        );
      },
    );
  }
}

class _PiecePainter extends CustomPainter {
  final ui.Image image;
  final Rect src;

  _PiecePainter({required this.image, required this.src});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      src,
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
