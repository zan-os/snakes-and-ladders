import 'package:flutter/material.dart';

import '../game_board/board_widget.dart';

class SnakesAndLaddersPage extends StatefulWidget {
  const SnakesAndLaddersPage({super.key});

  @override
  State<SnakesAndLaddersPage> createState() => _SnakesAndLaddersPageState();
}

class _SnakesAndLaddersPageState extends State<SnakesAndLaddersPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [GameBoardWidget()]);
  }
}
