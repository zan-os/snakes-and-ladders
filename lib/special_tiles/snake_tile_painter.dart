// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:snakes_and_ladders/game_board/model/tile_effect.dart';

class SnakeTilePainter extends CustomPainter {
  final Offset start;
  final Offset end;
  final TileEffectType tileType;

  SnakeTilePainter({
    required this.start,
    required this.end,
    required this.tileType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = sqrt(dx * dx + dy * dy);
    final direction = Offset(dx / distance, dy / distance);
    final perpendicular = Offset(-direction.dy, direction.dx);

    final segmentCount = 50;
    final waveAmplitude = (distance / 15).clamp(2, 10);
    final waveFrequency = (distance / 40).clamp(2, 10).round();

    final List<Offset> snakePoints = [];

    for (int i = 0; i <= segmentCount; i++) {
      final t = i / segmentCount;
      final basePoint = Offset.lerp(start, end, t)!;
      final waveOffset = sin(t * pi * waveFrequency) * waveAmplitude;
      final curvedPoint = basePoint + perpendicular * waveOffset;
      snakePoints.add(curvedPoint);
    }

    // Gambar tubuh ular (dari kepala ke ekor)
    for (int i = 0; i < snakePoints.length - 1; i++) {
      final t = i / (snakePoints.length - 1);
      final strokeWidth = lerpDouble(6.0, 2.0, t)!; // Kepala besar, ekor kecil

      final paint = Paint()
        ..color = Colors.green.shade700
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(snakePoints[i], snakePoints[i + 1], paint);
    }

    // Setelah snakePoints selesai dibuat dan setelah menggambar tubuh ular
    final spotPaint = Paint()..color = Colors.white;

    // Hitung jumlah totol berdasarkan panjang ular
    final double spotSpacing = 20.0; // jarak antar totol
    final int spotCount = max(1, (distance / spotSpacing).floor());

    for (int i = 0; i < spotCount; i++) {
      final t = i / (spotCount - 1);
      final index = (t * (snakePoints.length - 1)).round();
      final radius = lerpDouble(1.5, 3.0, 1 - t)!;
      canvas.drawCircle(snakePoints[index], radius, spotPaint);
    }

    // ==== Kepala ular berbentuk segitiga pipih (Viper) ====
    final head = snakePoints.first;
    final nextPoint = snakePoints[1];
    final headDirection = (head - nextPoint).normalize();
    final headPerpendicular = Offset(-headDirection.dy, headDirection.dx);

    final headLength = 14.0;
    final headWidth = 10.0;
    final backOffset = headDirection * (headLength * 0.4);

    final tip =
        head + headDirection * headLength; // Titik ujung kepala (lancip)
    final leftBack = head - backOffset + headPerpendicular * headWidth;
    final rightBack = head - backOffset - headPerpendicular * headWidth;

    // Membuat path kepala dengan ujung lancip dan belakang sedikit melengkung
    final path = Path()
      ..moveTo(leftBack.dx, leftBack.dy)
      ..lineTo(tip.dx, tip.dy) // sisi kiri ke ujung depan
      ..lineTo(rightBack.dx, rightBack.dy) // sisi kanan ke belakang
      ..quadraticBezierTo(
        head.dx,
        head.dy, // titik tengah untuk lengkungan halus ke sisi kiri belakang
        leftBack.dx,
        leftBack.dy,
      )
      ..close();

    final headPaint = Paint()
      ..color = Colors.green.shade900
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, headPaint);

    // (Optional) mata ular
    final eyeOffset = head + headPerpendicular * 3 + headDirection * 6;
    canvas.drawCircle(eyeOffset, 1.5, Paint()..color = Colors.black);
    final eyeOffset2 = head - headPerpendicular * 3 + headDirection * 6;
    canvas.drawCircle(eyeOffset2, 1.5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(SnakeTilePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SnakeTilePainter oldDelegate) => false;
}

extension on Offset {
  Offset normalize() {
    final len = distance;
    return len == 0 ? this : this / len;
  }
}
