import 'dart:ui';

import 'package:snakes_and_ladders/player_pieces/model/player_model.dart';

/// Manages the turn order and movement state for a list of players
class TurnManager {
  final List<PlayerModel> players;

  /// The index of the player whose turn it currently is.
  int _currentPlayerIndex = 0;

  TurnManager({required this.players});

  /// Returns the [PlayerModel] of the current player.
  PlayerModel get currentPlayer => players[_currentPlayerIndex];

  /// Indicates whether a player is currently moving.
  bool _isMoving = false;

  /// Returns true if a player is currently moving.
  bool get isMoving => _isMoving;

  bool _readyForNextMove = true;
  bool get readyForNextMove => _readyForNextMove;

  /// Advances the turn to the next player in the list.
  /// Wraps around to the first player after the last.
  void nextTurn() {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % players.length;
  }

  /// Resets the turn order to the first player.
  void resetTurns() {
    _currentPlayerIndex = 0;
  }

  /// Sets the movement state to true, indicating a player is moving.
  void startMoving() {
    _isMoving = true;
  }

  /// Sets the movement state to false, indicating no player is moving.
  void stopMoving() {
    _isMoving = false;
  }

  void setReadyForNextMove(bool value) {
    _readyForNextMove = value;
  }

  /// Updates the current player's position and rectangle on the board.
  ///
  /// [newPosition] is the new board position.
  /// [newRect] is the new rectangle representing the player's location.
  void updateCurrentPlayerPosition(int newPosition, Rect newRect) {
    players[_currentPlayerIndex] = players[_currentPlayerIndex].copyWith(
      currentPosition: newPosition,
      currentPositionRect: newRect,
    );
  }
}
