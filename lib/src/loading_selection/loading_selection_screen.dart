import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../level_selection/jigsaw_info.dart';
import '../level_selection/piece_image.dart';

class LoadingSelectionScreen extends StatefulWidget {
  final JigsawInfo level;

  const LoadingSelectionScreen({super.key, required this.level});

  @override
  State<LoadingSelectionScreen> createState() => _LoadingSelectionScreenState();
}

//GoRouter.of(context).go('/play/loading/', extra: item);
class _LoadingSelectionScreenState extends State<LoadingSelectionScreen> {
  double p = 0;
  int date = 0;

  @override
  void initState() {
    super.initState();
    date = DateTime.now().microsecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(children: [
          PieceImage(
            pictureUrl: widget.level.smallimage,
          ),
          PieceImage(
            pictureUrl: widget.level.image,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return Container();
            },
            progress: () {
              debugPrint("complete: $p");
              int now = DateTime.now().microsecondsSinceEpoch;
              debugPrint('now $now');
              debugPrint('date $date');
              debugPrint('diff ${now - date}');
              debugPrint("complete: 22");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Future.delayed(Duration(milliseconds: 1500), () async {
                  GoRouter.of(context)
                      .go('/play/session/', extra: widget.level);
                });
              });
            },
          ),
          // if (adsControllerAvailable) ...[
          //   Container(
          //     height: 80.h,
          //     color: Colors.white,
          //     child: Center(child: BannerAdWidget()),
          //   )
          // ],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 0.1.sh),
              width: 0.9.sw,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  height: 30.h,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ),
                Text(
                  "loading...",
                )
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
