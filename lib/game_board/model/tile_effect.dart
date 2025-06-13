enum TileEffectType { snake, ladder }

class TileEffect {
  final int from;
  final int to;
  final TileEffectType type;

  TileEffect({required this.from, required this.to, required this.type});

  @override
  String toString() {
    return 'TileEffect(from: $from, to: $to, type: $type)';
  }

  tojson() {
    return {'from': from, 'to': to, 'type': type.toString().split('.').last};
  }
}
