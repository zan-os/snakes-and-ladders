import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:snakes_and_ladders/extension/extensions.dart';
import 'package:snakes_and_ladders/game_board/model/board_model.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({super.key});

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  final int crossAxisCount = 10;
  final int tileTotal = 100;

  List<GlobalKey> tileKeys = [];
  List<BoardModel> boardTiles = [];

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

      // Trigger a rebuild to ensure the board model is ready
      setState(() {});
    });
  }

  void _initializeTileKeys() {
    tileKeys = List.generate(tileTotal, (index) => GlobalKey());
  }

  void _generateBoardModel() {
    boardTiles = List.generate(tileTotal, (index) {
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
        pos: pos + 1, // +1 to make it 1-indexed
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
      return element.copyWith(rect: tileKeys[index].globalKeyPaintBounds(15));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
        ),
        itemCount: tileTotal,
        itemBuilder: (context, index) {
          final tile = boardTiles[index];

          return Container(
            key: tileKeys[index],
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(tile.pos.toString()),
            ),
          );
        },
      ),
    );
  }
}
