class Game {
  final int gameId;
  final String playerOne;
  final String playerTwo;
  final int status;

  Game({
    required this.gameId,
    required this.playerOne,
    required this.playerTwo,
    required this.status,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      gameId: json['gameId'],
      playerOne: json['playerOne'],
      playerTwo: json['playerTwo'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'playerOne': playerOne,
      'playerTwo': playerTwo,
      'status': status,
    };
  }
}
