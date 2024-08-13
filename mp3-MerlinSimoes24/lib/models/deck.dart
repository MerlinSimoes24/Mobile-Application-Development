import 'flashcard.dart';

class Deck {
  final int id; // Unique ID for the deck
  String title;
  List<Flashcard> flashcards;

  Deck({
    required this.id,
    required this.title,
    required this.flashcards,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'flashcards': flashcards.map((flashcard) => flashcard.toMap()).toList(),
    };
  }

  static Deck fromMap(Map<String, dynamic> map) {
    List<dynamic> flashcardsList = map['flashcards'];

    return Deck(
      id: map['id'] as int,
      title: map['title'] as String,
      flashcards: flashcardsList.map((flashcardMap) => Flashcard.fromMap(flashcardMap as Map<String, dynamic>)).toList() as List<Flashcard>,
    );
  }
}
