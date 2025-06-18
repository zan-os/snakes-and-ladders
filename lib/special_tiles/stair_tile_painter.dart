// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snakes_and_ladders/game_board/model/tile_effect.dart';

class LadderTilePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final TileEffectType tileType;

  LadderTilePainter({
    required this.start,
    required this.end,
    required this.tileType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 1.5;

    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);

    const double stepSpacing = 40.0;
    final int steps = max(
      5,
      (distance / stepSpacing).floor(),
    ); // minimal 2 agar ada ruang antar tangga

    const double sideOffset = 8.0;
    final direction = Offset(
      dx / distance,
      dy / distance,
    ); // unit vector arah tangga
    final perpendicular = Offset(-direction.dy, direction.dx); // tegak lurus

    final offsetLeft = start + perpendicular * -sideOffset;
    final offsetRight = start + perpendicular * sideOffset;
    final endLeft = end + perpendicular * -sideOffset;
    final endRight = end + perpendicular * sideOffset;

    // Tiang kiri & kanan
    canvas.drawLine(offsetLeft, endLeft, paint);
    canvas.drawLine(offsetRight, endRight, paint);

    // Start anak tangga dari t = 0.15
    const double tStart = 0.15;
    final double tStep =
        (1.0 - tStart * 2) / (steps - 1); // kurangi dari dua ujung

    for (int i = 0; i < steps; i++) {
      final t = tStart + i * tStep;
      final centerPoint = Offset.lerp(start, end, t)!;

      final stepLeft = centerPoint + perpendicular * -sideOffset;
      final stepRight = centerPoint + perpendicular * sideOffset;

      canvas.drawLine(stepLeft, stepRight, paint);
    }
  }

  @override
  bool shouldRepaint(LadderTilePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(LadderTilePainter oldDelegate) => false;
}
