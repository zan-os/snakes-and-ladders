// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class PlayerPiecesWidget extends StatelessWidget {
  const PlayerPiecesWidget({
    super.key,
    required this.playerPosition,
    required this.playerName,
  });

  final Offset playerPosition;
  final String playerName;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 0),
      top: playerPosition.dy,
      left: playerPosition.dx,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: Center(
          child: Text(
            playerName,
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        ),
      ),
    );
  }
}
