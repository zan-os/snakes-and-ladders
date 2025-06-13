// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class BoardModel {
  final int pos;
  final Rect rect;
  final Map<int, int> snakes;
  final Map<int, int> ladders;
  final List<int> playersAtPosition;
  final TileType tileType;

  const BoardModel({
    this.pos = 0,
    this.rect = Rect.zero,
    this.snakes = const {},
    this.ladders = const {},
    this.playersAtPosition = const [],
    this.tileType = TileType.normal,
  });

  BoardModel copyWith({
    int? pos,
    Rect? rect,
    Map<int, int>? snakes,
    Map<int, int>? ladders,
    List<int>? playersAtPosition,
    TileType? tileType,
  }) {
    return BoardModel(
      pos: pos ?? this.pos,
      rect: rect ?? this.rect,
      snakes: snakes ?? this.snakes,
      ladders: ladders ?? this.ladders,
      playersAtPosition: playersAtPosition ?? this.playersAtPosition,
      tileType: tileType ?? this.tileType,
    );
  }
}

enum TileType { normal, snakeStart, ladderStart, finish }
