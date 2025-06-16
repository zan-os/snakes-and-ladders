import 'dart:developer';
import 'dart:math' hide log;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:snakes_and_ladders/extension/global_key_extensions.dart';
import 'package:snakes_and_ladders/game_board/model/board_model.dart';
import 'package:snakes_and_ladders/helper/tile_effect_manager.dart';
import 'package:snakes_and_ladders/helper/turn_manager.dart';
import 'package:snakes_and_ladders/player_pieces/model/player_model.dart';
import 'package:snakes_and_ladders/player_pieces/player_pieces.dart';
import 'package:snakes_and_ladders/special_tiles/special_tiles_painter.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({super.key});

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  late TurnManager turnManager;

  final SpecialTilesManager specialTileManager = SpecialTilesManager();
  final TextEditingController diceValueController = TextEditingController();

  final int crossAxisCount = 10;
  final int tileTotal = 100;

  List<GlobalKey> tileKeys = [];
  List<BoardModel> boardTiles = [];
  List<PlayerModel> players = [];

  @override
  void initState() {
    super.initState();

    // Initialize the list of GlobalKeys for each tile
    // This is necessary to ensure that each tile can be uniquely identified
    _initializeTileKeys();

    // Generate the board model after the first frame is rendered
    _generateBoardModel();

    // Generate tile effects for the game board
    specialTileManager.generateTileEffects(
      boardSize: tileTotal,
      snakeCount: 4,
      ladderCount: 4,
      minDistance: 5,
    );

    // Trigger a rebuild to ensure the board model is ready
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the rectangle for each tile based on its GlobalKey
      // This is necessary to ensure that the tiles have their positions set correctly
      _setTileRect();

      // Set the players for the game
      // This is necessary to ensure that the players are initialized correctly
      _setPlayers();

      // Initialize the TurnManager with the players
      // This is necessary to ensure that the turn management system is ready
      _initializeTurnManager();

      // Trigger a rebuild to ensure the board model is ready
      setState(() {});
    });
  }

  void _initializeTileKeys() {
    tileKeys = List.generate(tileTotal, (index) => GlobalKey());
  }

  void _generateBoardModel() {
    boardTiles = List.generate(tileKeys.length, (index) {
      final row = index ~/ crossAxisCount;
      final column = index % crossAxisCount;

      // Determine the position of the tile
      int pos = 0;
      if (row % 2 == 0) {
        pos = row * crossAxisCount + column;
      } else {
        pos = row * crossAxisCount + (crossAxisCount - column - 1);
      }

      // Create a BoardModel for each tile
      return BoardModel(
        pos: pos,
        snakes: {},
        ladders: {},
        playersAtPosition: [],
        tileType: TileType.normal,
      );
    });
  }

  void _setTileRect() {
    boardTiles = boardTiles.mapIndexed((index, element) {
      final row = index ~/ crossAxisCount;
      final column = index % crossAxisCount;

      // Determine the position of the tile
      int pos = 0;
      if (row % 2 == 0) {
        pos = row * crossAxisCount + column;
      } else {
        pos = row * crossAxisCount + (crossAxisCount - column - 1);
      }

      // Update the rectangle of each tile based on its GlobalKey
      return element.copyWith(rect: tileKeys[pos].getGlobalPaintBounds(15));
    }).toList();
  }

  void _setPlayers() {
    // Initialize static players for the game temporarily for development
    // In a next development, this would be dynamic based on user input or game state
    players = List.generate(
      1,
      (index) => PlayerModel(
        playerName: (index + 1).toString(),
        playerId: index + 1,
        currentPosition: 0,
        currentPositionRect: boardTiles.first.rect,
      ),
    );
  }

  void _initializeTurnManager() {
    // Initialize the TurnManager with the players
    turnManager = TurnManager(players: players);
  }

  int diceValueOverride = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Display prototype label
            const Text(
              'Snakes and Ladders Game Prototype :D',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Display the game board as a grid
            SizedBox(
              height: 400,
              width: 400,
              child: GridView.builder(
                shrinkWrap: true,
                reverse: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                ),
                itemCount: 100,
                itemBuilder: (context, index) {
                  final tile = boardTiles[index];

                  return Container(
                    key: tileKeys[index],
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        (tile.pos + 1).toString(),
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Display temporary roll button
            ElevatedButton(
              onPressed: () async {
                // Check if the player is already moving
                if (turnManager.isMoving ||
                    turnManager.readyForNextMove == false) {
                  log('Player is already moving, please wait.');
                  return;
                }

                // Check if the player is ready for the next move
                turnManager.startMoving();
                turnManager.setReadyForNextMove(false);

                // Roll the dice and move the player
                final dice = (diceValueOverride == 0)
                    ? Random().nextInt(6) + 1
                    : diceValueOverride;

                for (var i = 0; i < dice; i++) {
                  // Check if the player is already at the last tile
                  if (turnManager.currentPlayer.currentPosition >=
                      tileTotal - 1) {
                    log('Player is already at the last tile.');
                    turnManager.stopMoving();
                    turnManager.setReadyForNextMove(true);
                    return;
                  }

                  final nextPosition =
                      turnManager.currentPlayer.currentPosition + 1;

                  turnManager.updateCurrentPlayerPosition(
                    nextPosition,
                    boardTiles[nextPosition].rect,
                  );
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 500));
                }

                final currentPos = turnManager.currentPlayer.currentPosition;
                final effect = specialTileManager.getTileEffectForPosition(
                  currentPos,
                );

                // Stop moving the player and proceed to the next turn
                turnManager.stopMoving();

                if (effect != null && turnManager.isMoving == false) {
                  await Future.delayed(Duration(milliseconds: 100));
                  log(
                    'Triggered ${effect.type.name} from ${effect.from} to ${effect.to}',
                  );

                  turnManager.updateCurrentPlayerPosition(
                    effect.to - 1, // Adjust for zero-based index
                    boardTiles[effect.to - 1]
                        .rect, // Adjust for zero-based index
                  );
                  setState(() {});
                }

                diceValueOverride = 0; // Reset the override value
                diceValueController.clear(); // Clear the text field

                // Move to the next turn
                turnManager.nextTurn();
                turnManager.setReadyForNextMove(true);

                setState(() {});
              },
              child: Text(
                (diceValueOverride == 0) ? 'Roll Dice' : 'Move Player',
              ),
            ),
            Container(
              height: 50,
              width: 200,
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: diceValueController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dice Value Override',
                ),
                onChanged: (value) {
                  diceValueOverride = int.tryParse(value) ?? 0;
                  setState(() {});
                },
              ),
            ),
          ],
        ),

        // Display special tiles
        ...specialTileManager.tileEffects.map(
          (specialTiles) => CustomPaint(
            size: Size(100, 100),
            painter: SpecialTilesPainter(
              start: boardTiles[specialTiles.from - 1].rect.center,
              end: boardTiles[specialTiles.to - 1].rect.center,
              tileType: specialTiles.type,
            ),
          ),
        ),

        // Display the player pieces on the board
        ...players.map(
          (player) => PlayerPiecesWidget(
            playerPosition: player.currentPositionRect.center,
            playerName: player.playerName,
          ),
        ),
      ],
    );
  }
}
