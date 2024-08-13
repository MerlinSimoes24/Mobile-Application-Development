import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/flashcard.dart';
import 'quiz.dart';
import 'cardeditor.dart';

// ignore: must_be_immutable
class CardList extends StatefulWidget {
  final String deckTitle;
  List<Deck> decks;

  CardList({
    Key? key,
    required this.deckTitle,
    required this.decks,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  List<Flashcard> flashcards = [];
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    loadFlashcards();
  }

  void loadFlashcards() {
    for (final deck in widget.decks) {
      if (deck.title == widget.deckTitle) {
        flashcards = deck.flashcards;
        // Sort the flashcards in alphabetical order right after loading
        flashcards.sort((a, b) => a.question.compareTo(b.question));
        break;
      }
    }
    setState(() {});
  }

  void toggleSort() {
    setState(() {
      isAscending = !isAscending;
      flashcards.sort((a, b) {
        if (isAscending) {
          return a.question.compareTo(b.question);
        } else {
          return b.question.compareTo(a.question);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckTitle),
        actions: [
          IconButton(
            icon: Icon(isAscending ? Icons.sort_by_alpha : Icons.schedule),
            onPressed: toggleSort,
            tooltip: isAscending ? 'Sort Descending' : 'Sort Ascending', // Adding tooltip for better UX
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Quiz(
                    deckTitle: widget.deckTitle,
                    decks: widget.decks, // Pass the 'decks' list to Quiz
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: 1,
        ),
        itemCount: flashcards.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.orange[200],
            child: InkWell(
              onTap: () async {
                final newDeck = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CardEditor(
                        initialQuestion: flashcards[index].question,
                        initialAnswer: flashcards[index].answer,
                        isDeletable: false,
                        decks: widget.decks, // Pass 'decks' to CardEditor
                        decksTitle: widget.deckTitle),
                  ),
                );
                if (newDeck != null) {
                  // Update the decks list with the new deck
                  setState(() {
                    widget.decks = newDeck;
                  });

                  loadFlashcards();
                }
              },
              child: Center(
                child: Text(
                  flashcards[index].question,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newDeck = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardEditor(
                  initialQuestion: '',
                  initialAnswer: '',
                  isDeletable: true,
                  decks: widget.decks, // Pass 'decks' to CardEditor
                  decksTitle: widget.deckTitle),
            ),
          );
          if (newDeck != null) {
            // Update the decks list with the new deck
            setState(() {
              widget.decks = newDeck;
            });

            loadFlashcards();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
