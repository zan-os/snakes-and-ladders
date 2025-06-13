import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect globalKeyPaintBounds(double piecesSize) {
    final RenderBox? renderBox =
        currentContext?.findRenderObject() as RenderBox?;
    final translation = renderBox?.getTransformTo(null).getTranslation();
    if (translation != null && renderBox?.paintBounds != null) {
      final offset = Offset(
        translation.x - piecesSize / 2,
        translation.y - piecesSize / 2,
      );
      return renderBox!.paintBounds.shift(offset);
    } else {
      return Rect.zero;
    }
  }
}
