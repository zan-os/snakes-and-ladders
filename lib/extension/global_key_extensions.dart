import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  /// Returns the global paint bounds of the widget associated with this [GlobalKey].
  ///
  /// [piecesSize] is used to adjust the offset so that the bounds are centered
  /// around the widget's position.
  ///
  /// Returns a [Rect] representing the global bounds, or [Rect.zero] if unavailable.
  ///
  /// credit: https://medium.easyread.co/how-to-get-widget-coordinates-in-flutter-ui-dart-extension-4-d59dc15a9e3f
  Rect getGlobalPaintBounds(double piecesSize) {
    final renderObject = currentContext?.findRenderObject();
    if (renderObject is RenderBox && renderObject.attached) {
      final renderBox = renderObject;
      final translation = renderBox.getTransformTo(null).getTranslation();

      final offset = Offset(
        translation.x - (piecesSize / 2),
        translation.y - (piecesSize / 2),
      );
      return renderBox.paintBounds.shift(offset);
    }

    return Rect.zero;
  }
}

extension OffsetNormalize on Offset {
  Offset normalize() {
    final length = distance;
    if (length == 0) return this;
    return this / length;
  }
}
