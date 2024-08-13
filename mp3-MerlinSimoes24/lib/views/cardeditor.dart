import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/flashcard.dart';

class CardEditor extends StatefulWidget {
  final String initialQuestion;
  final String initialAnswer;
  final bool isDeletable;
  final List<Deck> decks;
  final String decksTitle;

  const CardEditor({
    super.key,
    required this.initialQuestion,
    required this.initialAnswer,
    required this.isDeletable,
    required this.decks,
    required this.decksTitle,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CardEditorState createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {
  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    questionController.text = widget.initialQuestion;
    answerController.text = widget.initialAnswer;
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    super.dispose();
  }

  void saveChanges() {
    String updatedQuestion = questionController.text;
    String updatedAnswer = answerController.text;

    if (widget.isDeletable) {
      // Create a new card
      Flashcard newCard = Flashcard(
          id: widget.decks.hashCode,
          deckId: widget.decksTitle.hashCode.toString(),
          question: updatedQuestion,
          answer: updatedAnswer);

      // Add the new card to the deck
      List<Deck> updatedDecks = widget.decks.map((deck) {
        if (deck.title == widget.decksTitle) {
          return Deck(
            id: widget.decksTitle.hashCode,
            title: deck.title,
            flashcards: [...deck.flashcards, newCard],
          );
        }
        return deck;
      }).toList();

      Navigator.pop(context, updatedDecks);
    } else {
      List<Deck> updatedDecks = widget.decks.map((deck) {
        if (deck.title == widget.decksTitle) {
          List<Flashcard> updatedFlashcards = deck.flashcards.map((flashcard) {
            if (flashcard.question == widget.initialQuestion) {
              return Flashcard(
                  id : updatedQuestion.hashCode,
                  deckId: widget.decksTitle.hashCode.toString(),
                  question: updatedQuestion, answer: updatedAnswer);
            }
            return flashcard;
          }).toList();

          return Deck(
            id: widget.decksTitle.hashCode,
            title: deck.title,
            flashcards: updatedFlashcards,
          );
        }
        return deck;
      }).toList();

      Navigator.pop(context, updatedDecks);
    }
  }

  void deleteCard() {
      List<Deck> updatedDecks = widget.decks.map((deck) {
        if (deck.title == widget.decksTitle) {
          List<Flashcard> updatedFlashcards = deck.flashcards
              .where((flashcard) => flashcard.question != widget.initialQuestion)
              .toList();

          return Deck(
            id: widget.decksTitle.hashCode,
            title: deck.title,
            flashcards: updatedFlashcards,
          );
        }
        return deck;
      }).toList();

      Navigator.pop(context, updatedDecks);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Card'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Edit Card',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Question (Label)'),
            TextField(
              controller: questionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Answer (Label)'),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: saveChanges,
                  child: const Text('Save'),
                ),
                const SizedBox(width: 16),
                if (!widget.isDeletable) ...[
                  ElevatedButton(
                    onPressed: deleteCard,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
