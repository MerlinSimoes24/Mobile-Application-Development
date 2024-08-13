class Flashcard {
  final int id; // Unique ID for the flashcard
  String deckId;
  String question;
  String answer;
 

  Flashcard({
    required this.id,
    required this.deckId,
    required this.question,
    required this.answer,
    
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'deckId': deckId,
      'question': question,
      'answer': answer,
    };
  }

  static Flashcard fromMap(flashcardMap) {

    return Flashcard(
      id: flashcardMap['id'] as int,
      deckId: flashcardMap['deckId'] as String,
      question: flashcardMap['question'] as String,
      answer: flashcardMap['answer'] as String,
    );
  }

}