import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/flashcard.dart';
import 'package:mp3/views/deckeditor.dart';
import 'cardlist.dart'; // Import the card list class

class DeckList extends StatefulWidget {
  const DeckList({Key? key}) : super(key: key);

  @override
  _DeckListState createState() => _DeckListState();
}

class _DeckListState extends State<DeckList> {
  List<Deck> decks = [];

  @override
  void initState() {
    super.initState();
    loadDecks();
  }

  Future<void> loadDecks() async {
    final String jsonContent = await DefaultAssetBundle.of(context).loadString('assets/flashcards.json');
    final List<dynamic> jsonData = json.decode(jsonContent);

    for (final dynamic item in jsonData) {
      final String title = item['title'];
      final List<Flashcard> flashcards = (item['flashcards'] as List<dynamic>)
          .map((fc) => Flashcard(
              id: fc['question'].hashCode,
              deckId: title.hashCode.toString(),
              question: fc['question'],
              answer: fc['answer']))
          .toList();

      decks.add(Deck(id: title.hashCode, title: title, flashcards: flashcards));
    }

    setState(() {});
  }

  void updateDecks(List<Deck> updatedDecks) {
    setState(() {
      decks = updatedDecks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: const Center(
          child: Text(
            'Flashcard Decks',
            style: TextStyle(color: Colors.indigo),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black),
            onPressed: loadDecks,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = (constraints.maxWidth / 400).floor();

          return GridView.count(
            crossAxisCount: crossAxisCount,
            padding: const EdgeInsets.all(4),
            children: List.generate(
              decks.length,
              (index) => Card(
                color: Colors.yellow[100],
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CardList(
                          deckTitle: decks[index].title,
                          decks: decks,
                        ),
                      ),
                    ).then((value) => {
                      // Refresh decks in case they were updated
                      if (value != null) {
                        updateDecks(value)
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Center(child: Text('${decks[index].title} (${decks[index].flashcards.length} cards)')),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final updatedDecks = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeckEditor(
                                    deckTitle: decks[index].title,
                                    isCreating: false,
                                    decks: decks,
                                    deckIndex: index,
                                  ),
                                ),
                              );
                              if (updatedDecks != null) {
                                updateDecks(updatedDecks);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () async {
          final newDeck = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeckEditor(
                deckTitle: "", // Pass an empty string for the new deck title
                isCreating: true,
                decks: decks,
                deckIndex: 0,
              ),
            ),
          );
          if (newDeck != null) {
            updateDecks(newDeck);
          }
        },
        child: const Icon(Icons.add, color: Colors.green),
      ),
    );
  }
}
