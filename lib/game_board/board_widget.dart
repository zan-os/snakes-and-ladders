import 'package:flutter/material.dart';

class GameBoardWidget extends StatefulWidget {
  const GameBoardWidget({super.key});

  @override
  State<GameBoardWidget> createState() => _GameBoardWidgetState();
}

class _GameBoardWidgetState extends State<GameBoardWidget> {
  final int crossAxisCount = 10;
  final int tileTotal = 100;
  final tileKeys = List.generate(100, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: tileTotal,
      itemBuilder: (context, realIndex) {
        final row = realIndex ~/ crossAxisCount;
        final column = realIndex % crossAxisCount;

        int index = 0;

        if (row % 2 == 0) {
          index = row * crossAxisCount + column;
        } else {
          index = row * crossAxisCount + (crossAxisCount - column - 1);
        }

        return Container(
          key: tileKeys[index],
          decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(index.toString()),
          ),
        );
      },
    );
  }
}
