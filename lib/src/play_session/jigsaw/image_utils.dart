import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class ImageUtils {
  static double calculateScale(double targetSizeWidth, double targetSizeHeight,
      double imageSizeWidth, double imageSizeHeight) {
    double scale = 1.0;
    if (imageSizeWidth > targetSizeWidth ||
        imageSizeHeight > targetSizeHeight) {
      scale = min(
          targetSizeWidth / imageSizeWidth, targetSizeHeight / imageSizeHeight);
    } else {
      scale = max(
          targetSizeWidth / imageSizeWidth, targetSizeHeight / imageSizeHeight);
    }
    return scale;
  }

  static Vector2 fitCenter(
      double width, double height, double targetWidth, double targetHeight) {
    debugPrint("image.width:$width image.height:$height");

    double originalAspectRatio = 1.0;
    double targetAspectRatio = 1.0;
    double newWidth = 0.0;
    double newHeight = 0.0;

    // 计算原始图像和目标尺寸的宽高比
    originalAspectRatio = width / height;
    targetAspectRatio = targetWidth / targetHeight;

    // 如果原始宽高比大于目标宽高比，则需要缩放宽度
    if (originalAspectRatio > targetAspectRatio) {
      newWidth = targetWidth;
      newHeight = targetWidth / originalAspectRatio;
    } else {
      //否则，需要缩放高度
      newHeight = targetHeight;
      newWidth = targetHeight * originalAspectRatio;
    }
    debugPrint("image.new_width:$newWidth image.new_height:$newHeight");
    return Vector2(newWidth, newHeight);
  }
}
