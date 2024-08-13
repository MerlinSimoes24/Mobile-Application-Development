class GameData {
  final int id;
  final int status;
  final int turn;
  final String player1;
  final String player2;
  final List<String> ships;
  final List<String> wrecks;
  final List<String> shots;
  final List<String> sunk;

  GameData({
    required this.id,
    required this.status,
    required this.turn,
    required this.player1,
    required this.player2,
    required this.ships,
    required this.wrecks,
    required this.shots,
    required this.sunk,
  });

  factory GameData.fromJson(Map<String, dynamic> json) {
    return GameData(
      id: json['id'] ?? 0, // Providing a default value if null
      status: json['status'] ?? 0, // Providing a default value if null
      turn: json['turn'] ?? 0, // Providing a default value if null
      player1: json['player1'] ?? '', // Providing a default value if null
      player2: json['player2'] ?? '', // Providing a default value if null
      ships: List<String>.from(json['ships'] ?? []), // Providing a default empty list if null
      wrecks: List<String>.from(json['wrecks'] ?? []), // Providing a default empty list if null
      shots: List<String>.from(json['shots'] ?? []), // Providing a default empty list if null
      sunk: List<String>.from(json['sunk'] ?? []), // Providing a default empty list if null
    );
  }
}
