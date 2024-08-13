import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './PlayerGames.dart';
import './Board.dart';
import 'package:battleships/models/GameData.dart';

class BattleshipPage extends StatefulWidget {
  final String username;
  final String accessToken;

  const BattleshipPage({
    Key? key,
    required this.username,
    required this.accessToken,
  }) : super(key: key);

  @override
  _BattleshipState createState() => _BattleshipState();
}

class _BattleshipState extends State<BattleshipPage> {
  bool isSidebarOpen = false;
  List<GameData> gameResultsList = [];
  List<GameData> gameResultsListFull = [];

  @override
  void initState() {
    super.initState();
    fetchAllGames("");
  }

  void _toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  void _closeSidebar() {
    setState(() {
      isSidebarOpen = false;
    });
  }

  void _startNewGame() async {
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardPage(
          accessToken: widget.accessToken,
          aiBool: false,
          aiChoice: "",
        ),
      ),
    );

    if (result != null) {
      gameResultsList.add(GameData.fromJson(result));
      print('Game results list: $gameResultsList');
    }
  }

  Future<void> _startNewGameAiPopup() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Which AI do you want to play against?'),
          content: Column(
            children: [
              ListTile(
                title: const Text('Random'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewGameAi("random");
                },
              ),
              ListTile(
                title: const Text('Perfect'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewGameAi("perfect");
                },
              ),
              ListTile(
                title: const Text('One ship (A1)'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewGameAi("oneship");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _startNewGameAi(String aiType) async {
    Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoardPage(
          accessToken: widget.accessToken,
          aiBool: true,
          aiChoice: aiType,
        ),
      ),
    );

    fetchGameDetails("");

    if (result != null) {
      gameResultsList.add(GameData.fromJson(result));
    }
  }

  Future<void> fetchAllGames(String comp) async {
    const baseUrl = 'http://165.227.117.48/games';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> games = jsonDecode(response.body)["games"];
        List<GameData> gamesList = games.map((gameJson) => GameData.fromJson(gameJson)).toList();
        setState(() {
          gameResultsListFull = gamesList;
        });
      } else {
        print('Error fetching game details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching game details: $e');
    }
  }

  void deleteGame(int gameId) async {
    String apiUrl = 'http://165.227.117.48/games/$gameId';

    var response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${widget.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      fetchAllGames("");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Game $gameId has been deleted successfully.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to delete game $gameId. Status code: ${response.statusCode}');
    }
  }

  Future<void> fetchGameDetails(String comp) async {
    const baseUrl = 'http://165.227.117.48/games/';
    List<GameData> updatedGameResultsListFull = [];

    for (var gameData in gameResultsList) {
      final url = Uri.parse('$baseUrl${gameData.id}');

      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer ${widget.accessToken}',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> gameDetails = jsonDecode(response.body);

          if (comp == "complete") {
            if (gameDetails["turn"] == 0) {
              updatedGameResultsListFull.add(GameData.fromJson(gameDetails));
            }
          } else {
            updatedGameResultsListFull.add(GameData.fromJson(gameDetails));
          }

          print('Game details for game ${gameData.id}: $gameDetails');
        } else {
          print(
              'Error fetching game details for game ${gameData.id}: ${response.body}');
        }
      } catch (e) {
        print('Error fetching game details for game ${gameData.id}: $e');
      }
    }

    setState(() {
      gameResultsListFull = updatedGameResultsListFull;
    });
  }

  String getStatusText(int status, int turn, int position) {
    switch (status) {
      case 0: return 'Matchmaking';
      case 1: return '${gameResultsListFull.firstWhere((game) => game.id == position).player1} won';
      case 2: return '${gameResultsListFull.firstWhere((game) => game.id == position).player2} won';
      case 3: return turn == position ? 'Your Turn' : 'Opponent Turn';
      default: return 'Unknown Status';
    }
  }

  Widget gameRow(GameData game) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayGameBoard(
              accessToken: widget.accessToken,
              initialGameData: game,
            ),
          ),
        );
        fetchAllGames("");
      },
      child: Container(
        height: 100,
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
              child: Center(child: Text('#${game.id}')),
            ),
            SizedBox(
              height: 20,
              child: Center(child: Text(game.player2.isEmpty ? 'Waiting for opponent' : '${game.player1} vs ${game.player2}')),
            ),
            SizedBox(
              height: 20,
              child: Center(
                child: Text(getStatusText(game.status, game.turn, game.id)),
              ),
            ),
            ElevatedButton(
              onPressed: () => deleteGame(game.id),
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Battleships"),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _toggleSidebar,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => fetchAllGames(""),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: isSidebarOpen ? 220 : 0,
            child: Container(
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Battleships",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Logged in as ${widget.username}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Divider(color: Colors.white, height: 20, thickness: 1),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text("New game"),
                    onTap: _startNewGame,  // Add new game function
                  ),
                  ListTile(
                    leading: Icon(Icons.gamepad),
                    title: Text("New game (AI)"),
                    onTap: _startNewGameAiPopup,
                  ),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text("Show completed games"),
                    onTap: () => fetchAllGames("complete"),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Log out"),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: GestureDetector(
              onTap: _closeSidebar,
              child: ListView(
                children: gameResultsListFull.map((game) => gameRow(game)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
