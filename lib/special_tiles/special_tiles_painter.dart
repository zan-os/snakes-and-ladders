// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:snakes_and_ladders/game_board/model/tile_effect.dart';

class SpecialTilesPainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final TileEffectType tileType;

  SpecialTilesPainter({
    required this.start,
    required this.end,
    required this.tileType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = switch (tileType) {
        TileEffectType.snake => Colors.red.shade400,

        TileEffectType.ladder => Colors.green.shade400,
      }
      ..style = PaintingStyle.fill;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(SpecialTilesPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SpecialTilesPainter oldDelegate) => false;
}
