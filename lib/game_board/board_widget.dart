import 'dart:developer';
import 'dart:math' hide log;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:snakes_and_ladders/extension/global_key_extensions.dart';
import 'package:snakes_and_ladders/game_board/model/board_model.dart';
import 'package:snakes_and_ladders/helper/turn_manager.dart';
import 'package:snakes_and_ladders/player_pieces/model/player_model.dart';
import 'package:snakes_and_ladders/player_pieces/player_pieces.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({super.key});

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  late TurnManager turnManager;

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
      // Update the rectangle of each tile based on its GlobalKey
      return element.copyWith(rect: tileKeys[index].getGlobalPaintBounds(15));
    }).toList();
  }

  void _setPlayers() {
    // Initialize static players for the game temporarily for development
    // In a next development, this would be dynamic based on user input or game state
    players = List.generate(
      4,
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Display the game board as a grid
            SizedBox(
              height: 400,
              width: 400,
              child: GridView.builder(
                shrinkWrap: true,
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
                      child: Text((tile.pos + 1).toString()),
                    ),
                  );
                },
              ),
            ),

            // Display temporary roll button
            ElevatedButton(
              onPressed: () async {
                // Check if the player is already moving
                if (turnManager.isMoving) {
                  log('Player is already moving, please wait.');
                  return;
                }

                // Start the turn for the current player
                turnManager.startMoving();

                // Roll the dice and move the player
                final dice = Random().nextInt(6) + 1;
                log(
                  'Dice rolled: $dice for ${turnManager.currentPlayer.playerName}',
                );

                for (var i = 0; i < dice; i++) {
                  final nextPosition =
                      turnManager.currentPlayer.currentPosition + 1;
                  log(
                    'Moving player ${turnManager.currentPlayer.playerName} to tile $nextPosition',
                  );
                  turnManager.updateCurrentPlayerPosition(
                    nextPosition,
                    boardTiles
                        .firstWhere((tile) => tile.pos == nextPosition)
                        .rect,
                  );
                  setState(() {});
                  await Future.delayed(Duration(milliseconds: 500));
                }

                // Stop moving the player and proceed to the next turn
                turnManager.stopMoving();

                turnManager.nextTurn();
              },
              child: Text('Move Player'),
            ),
          ],
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
