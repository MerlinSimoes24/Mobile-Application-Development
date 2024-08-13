import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:battleships/models/GameData.dart';  // Assuming this is the correct import path for GameData

class PlayGameBoard extends StatefulWidget {
  final String accessToken;
  final GameData initialGameData;

  PlayGameBoard({
    Key? key,
    required this.accessToken,
    required this.initialGameData,
  }) : super(key: key);

  @override
  _PlayGameBoardState createState() => _PlayGameBoardState();
}

class _PlayGameBoardState extends State<PlayGameBoard> {
  List<String> selectedShips = [];
  String? hoveredCell;
  late GameData gameData;

  @override
  void initState() {
    super.initState();
    gameData = widget.initialGameData;
  }

  bool isShipSelected(String cell) {
    return selectedShips.contains(cell);
  }

  void toggleShipSelection(String cell) {
    setState(() {
      if (selectedShips.contains(cell)) {
        selectedShips.remove(cell);
      } else {
        selectedShips.add(cell);
      }
    });
  }

  Future<void> startGame(List<String> selectedShips) async {
    const baseUrl = 'http://165.227.117.48/games/start';  // Adjust URL as needed
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'gameId': gameData.id,
          'ships': selectedShips,
        }),
      );

      if (response.statusCode == 200) {
        print('Game started successfully.');
        final gameDetails = jsonDecode(response.body);
        setState(() {
          gameData = GameData.fromJson(gameDetails);
        });
      } else {
        print('Failed to start game: ${response.body}');
      }
    } catch (e) {
      print('Error starting game: $e');
    }
  }

  Future<void> fetchGameDetails() async {
    const baseUrl = 'http://165.227.117.48/games/';
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
        setState(() {
          gameData = GameData.fromJson(gameDetails);
        });
      } else {
        print('Error fetching game details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching game details: $e');
    }
  }

  Widget _buildShipEmoji(String cell) {
    if (gameData.sunk.contains(cell)) {
      return const Text('💥', style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 255, 17, 0)));
    } else if (gameData.shots.contains(cell)) {
      return const Text('💣', style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 0, 0, 0)));
    } else if (gameData.wrecks.contains(cell)) {
      return const Text('🫧', style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 0, 47, 255)));
    } else if (gameData.ships.contains(cell)) {
      return const Text('🚢', style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 0, 47, 255)));
    }
    return const Text('');
  }

 Future<void> placeBooms(int gameId, String shot) async {
    final baseUrl = 'http://165.227.117.48/games/$gameId';

    try {
      final response = await http.put(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer ${widget.accessToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'shot': shot}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String message = responseData['message'];
        final bool sunkShip = responseData['sunk_ship'];
        final bool won = responseData['won'];

        if (won == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    Text('Message : $message   Sunk Ship: $sunkShip   Won '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Message : $message   Sunk Ship: $sunkShip'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }

        // You can update the UI or perform other actions based on the response
      } else {
        print('Error placing shot: ${response.body}');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(response.body),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        // Handle the error, show an alert, or perform other actions
      }
    } catch (e) {
      print('Error placing shot: $e');

      // Handle the error, show an alert, or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Play Game"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous page (Battleship.dart)
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Board UI
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                  width: 20, height: 20), // Placeholder for top-left corner
              for (var i = 1; i <= 5; i++)
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    '$i',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Increase crossAxisCount to include letters
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                if (index % 6 == 0) {
                  // Display vertical letters similar to horizontal numbers
                  final row = index ~/ 6;
                  final cell = String.fromCharCode('A'.codeUnitAt(0) + row);

                  return Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      cell,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  final row = index ~/ 6; // Adjust index to include letters
                  final col = index % 6;
                  final cell = String.fromCharCode('A'.codeUnitAt(0) + row) +
                      (col == 0 ? '' : col.toString());

                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        hoveredCell = cell;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoveredCell = null;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        // Check if it's a clickable cell (not a vertical letter)
                        if (col != 0) {
                          toggleShipSelection(cell);
                        }
                      },
                      child: Container(
                        color: isShipSelected(cell) || cell == hoveredCell
                            ? const Color.fromARGB(255, 49, 163, 215)
                            : Colors.white,
                        child: Center(
                          child: _buildShipEmoji(cell),
                        ),
                      ),
                    ),
                  );
                }
              },
              itemCount: 30, // Adjust itemCount accordingly
            ),
          ),
          // Submit button
          ElevatedButton(
            onPressed: () {
              startGame(selectedShips);
              fetchGameDetails();
              fetchGameDetails();
              if (selectedShips.isNotEmpty) {
                placeBooms(widget.initialGameData.id, selectedShips.last);
              } else {
                // Show a pop-up message
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text('No ships selected. ${selectedShips.last}'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
              ;
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
