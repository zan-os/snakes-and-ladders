// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class PlayerModel {
  final String playerName;
  final int playerId;
  final int currentPosition;
  final Rect currentPositionRect;

  PlayerModel({
    required this.playerName,
    required this.playerId,
    required this.currentPosition,
    required this.currentPositionRect,
  });

  @override
  String toString() {
    return 'Player: $playerName, ID: $playerId, Position: $currentPosition, Rect: $currentPositionRect';
  }

  PlayerModel copyWith({
    String? playerName,
    int? playerId,
    int? currentPosition,
    Rect? currentPositionRect,
  }) {
    return PlayerModel(
      playerName: playerName ?? this.playerName,
      playerId: playerId ?? this.playerId,
      currentPosition: currentPosition ?? this.currentPosition,
      currentPositionRect: currentPositionRect ?? this.currentPositionRect,
    );
  }
}
