import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mp3/models/deck.dart';
import 'package:mp3/models/flashcard.dart';
import 'package:mp3/utils/dbhelper.dart'; // Import the Deck class

class DeckEditor extends StatefulWidget {
   DeckEditor({
    Key? key,
    required this.deckTitle,
    required this.isCreating,
    required this.decks,
    required this.deckIndex,
  }) : super(key: key);

  final String deckTitle;
  final bool isCreating;
  final List<Deck> decks; // Change the data type of decks to List<Deck>
  final int deckIndex;
  List<Flashcard> originalOrder = [];

  @override
  // ignore: library_private_types_in_public_api
  _DeckEditorState createState() => _DeckEditorState();
}

class _DeckEditorState extends State<DeckEditor> {
  final TextEditingController _deckNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deckNameController.text = widget.deckTitle;
  }

  Future<void> handleSaveAction() async {
    final deckTitle = _deckNameController.text;

    if (widget.isCreating) {
      // Create a new deck
      final newDeck =
          Deck(id: deckTitle.hashCode, title: deckTitle, flashcards: []);

      widget.decks.add(newDeck);

      if (kDebugMode) {
        print('New deck created: $deckTitle');
      }
    } else {
      // Update the existing deck
      for (final deck in widget.decks) {
        if (deck.title == widget.deckTitle) {
          deck.title = deckTitle;
          break;
        }
      }
    }

    Navigator.pop(context, widget.decks);
  }

  Future<void> handleDeleteAction() async {
  if (widget.deckIndex >= 0 && widget.deckIndex < widget.decks.length) {
    widget.decks.removeAt(widget.deckIndex);
    DatabaseHelper.deleteFlashcard(widget.deckIndex).then((_) {
      }); 
      }
}

  @override
  Widget build(BuildContext context) {
    final bool isEditing = !widget.isCreating;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Deck' : 'Create Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Deck Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: TextFormField(
                controller: _deckNameController,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: handleSaveAction,
                  child: const Text('Save'),
                ),
                if (isEditing) ...[
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: handleDeleteAction,
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
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
