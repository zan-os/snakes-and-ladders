import 'dart:convert';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:collection/collection.dart';
import 'package:snakes_and_ladders/game_board/model/tile_effect.dart';

class SpecialTilesManager {
  final List<TileEffect> _tileEffects = [];

  List<TileEffect> get tileEffects => List.unmodifiable(_tileEffects);

  void generateTileEffects({
    required int boardSize,
    int snakeCount = 4,
    int ladderCount = 4,
    int minDistance = 5,
    Random? random,
  }) {
    // Ensure the board is large enough and counts are valid
    assert(boardSize > 2, 'Board size must be greater than 2.');
    assert(snakeCount >= 0 && ladderCount >= 0, 'Counts must be non-negative.');

    // Use provided Random or create a new one
    final rnd = random ?? Random();

    // Set to keep track of tiles already used by snakes/ladders
    final occupiedTilesPos = <int>{};

    // List to store generated effects
    final effects = <TileEffect>[];

    // Helper to mark tiles as occupied
    void addOccupiedTilePos(int from, int to) {
      occupiedTilesPos.add(from);
      occupiedTilesPos.add(to);
    }

    // Checks if a snake/ladder can be placed between 'from' and 'to'
    bool isValid(int from, int to, TileEffectType type) {
      if (occupiedTilesPos.contains(from)) return false; // Can't reuse 'from'
      if (occupiedTilesPos.contains(to)) return false; // Can't reuse 'to'
      if (type == TileEffectType.snake && to >= from) {
        return false; // Snakes go down
      }
      if (type == TileEffectType.ladder && to <= from) {
        return false; // Ladders go up
      }
      if ((from - to).abs() < minDistance) {
        return false; // Must be far enough apart
      }
      if (from <= 1 || from >= boardSize) return false; // Avoid first/last tile
      if (to <= 1 || to >= boardSize) return false; // Avoid first/last tile
      return true;
    }

    // Attempts to generate a valid snake or ladder
    TileEffect generateOne(TileEffectType type) {
      for (var attempt = 0; attempt < 1000; attempt++) {
        // Pick random positions (not first or last tile)
        final from = rnd.nextInt(boardSize - 1) + 2; // 2..boardSize-1
        final to = rnd.nextInt(boardSize - 1) + 2; // 2..boardSize-1
        if (isValid(from, to, type)) {
          addOccupiedTilePos(from, to);
          return TileEffect(from: from, to: to, type: type);
        }
      }
      // Give up after 1000 tries
      throw StateError('Unable to generate a valid $type after many attempts.');
    }

    // Generate snakes
    for (var i = 0; i < snakeCount; i++) {
      effects.add(generateOne(TileEffectType.snake));
    }
    // Generate ladders
    for (var i = 0; i < ladderCount; i++) {
      effects.add(generateOne(TileEffectType.ladder));
    }

    // Log the generated effects for debugging
    log(
      'Generated Tile Effects: ${effects.map((e) => jsonEncode(e.tojson())).toList()}',
      name: 'TileEffectManager',
    );

    log('Used From Positions: ${occupiedTilesPos.toList()}');

    // Store the generated effects in the manager
    _tileEffects
      ..clear()
      ..addAll(effects);
  }

  TileEffect? getTileEffectForPosition(int position) =>
      _tileEffects.firstWhereOrNull((e) => e.from - 1 == position);
}
