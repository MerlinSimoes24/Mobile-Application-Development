import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GameResult {
  final int gameId;
  final int playerPosition;
  final bool matched;

  GameResult(this.gameId, this.playerPosition, this.matched);
}

class BoardPage extends StatefulWidget {
  final String accessToken;
  final bool aiBool;
  final String aiChoice;

  const BoardPage({Key? key, required this.accessToken, required this.aiBool, required this.aiChoice})
      : super(key: key);

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  List<String> selectedShips = [];
  String? hoveredCell;
  int gameID = 0;
  int position = 0;
  bool matched = false;

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


  Future<void> startGame(bool aiBool, List<String> selectedShips) async {
    const url = 'http://165.227.117.48/games';

    final headers = {
      'Authorization': 'Bearer ${widget.accessToken}',
      'Content-Type': 'application/json',
    };

    final Map<String, dynamic> body = {
      'ships': selectedShips,
    };

    if (aiBool) {
      
      body['ai'] = widget.aiChoice;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        gameID = data['id'];
        position = data['player'] as int;
        matched = data['matched'];

        // Return the result object when the game starts successfully
        // ignore: use_build_context_synchronously
        Navigator.pop(
          context,
          {
            'gameId': gameID,
            'playerPosition': position,
            'matched': matched,
          },
        );
      } else {
        print('Error starting the game: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Ship"),
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
                          child: Text(cell),
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
              startGame(widget.aiBool, selectedShips);
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
