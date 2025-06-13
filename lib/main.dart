import 'package:flutter/material.dart';
import 'package:snakes_and_ladders/snakes_and_ladders/snakes_and_ladders_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: SnakesAndLaddersPage()));
  }
}
