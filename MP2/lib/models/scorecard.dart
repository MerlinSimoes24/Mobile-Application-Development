import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
enum ScoreCategory {
  ones("Ones"),
  twos("Twos"),
  threes("Threes"),
  fours("Fours"),
  fives("Fives"),
  sixes("Sixes"),
  threeOfAKind("Three of a Kind"),
  fourOfAKind("Four of a Kind"),
  fullHouse("Full House"),
  smallStraight("Small Straight"),
  largeStraight("Large Straight"),
  yahtzee("Yahtzee"),
  chance("Chance"),
  totalScore("Total Score");
  
  const ScoreCategory(this.name);
  
  final String name;
}
class CategoryData {
  bool booleanValue;
  int ?intValue;
  CategoryData(this.booleanValue, this.intValue);
}
class ScoreCard extends ChangeNotifier{
  bool isTapped = false;
    bool entryAdded = false;

  final Map<ScoreCategory, CategoryData> _scores = { 
    for (var category in ScoreCategory.values) category: CategoryData(false, 0)
  } ;

  CategoryData? operator [](ScoreCategory category) => _scores[category];
  bool get completed => _scores.values.where((data) => data.booleanValue).length == ScoreCategory.values.length;

  //int get total => _scores.values.whereNotNull().sum;
  //int get total => _scores.values.whereNotNull().map((data) => data.intValue!).sum;
  int get total => _scores.values
    .whereNotNull()
    .where((data) => data.booleanValue == true)
    .map((data) => data.intValue!)
    .sum;
  void clear() {
    _scores.forEach((key, value) {
      value.intValue = 0;
      value.booleanValue = false;
    });
  }

  void registerScore(ScoreCategory category, List<int> dice) {
    final uniqueVals = Set.from(dice);

    if (_scores[category]!.booleanValue != true) {
    switch(category) {
      case ScoreCategory.ones:
        _scores[category]!.intValue = dice.where((d) => d == 1).sum;
        break;

      case ScoreCategory.twos:
        _scores[category]!.intValue = dice.where((d) => d == 2).sum;
        break;

      case ScoreCategory.threes:
        _scores[category]!.intValue = dice.where((d) => d == 3).sum;
        break;

      case ScoreCategory.fours:
        _scores[category]!.intValue = dice.where((d) => d == 4).sum;
        break;

      case ScoreCategory.fives:
        _scores[category]!.intValue = dice.where((d) => d == 5).sum;
        break;

      case ScoreCategory.sixes:
        _scores[category]!.intValue = dice.where((d) => d == 6).sum;
        break;

      case ScoreCategory.threeOfAKind:
        if (dice.any((d) => dice.where((d2) => d2 == d).length >= 3)) {
          _scores[category]!.intValue = dice.sum;
        } else {
          _scores[category]!.intValue = 0;
        }
        break;
        
      case ScoreCategory.fourOfAKind:
        if (dice.any((d) => dice.where((d2) => d2 == d).length >= 4)) {
          _scores[category]!.intValue = dice.sum;
        } else {
          _scores[category]!.intValue = 0;
        }
        break;
        
      case ScoreCategory.fullHouse:
        if (uniqueVals.length == 2 
          && uniqueVals.any((d) => dice.where((d2) => d2 == d).length == 3)) {
          _scores[category]!.intValue = 25;
        } else {
          _scores[category]!.intValue = 0;
        }
        break;

      case ScoreCategory.smallStraight:
        if (uniqueVals.containsAll([1, 2, 3, 4]) 
            || uniqueVals.containsAll([2, 3, 4, 5]) 
            || uniqueVals.containsAll([3, 4, 5, 6])) {
          _scores[category]!.intValue = 30;
        } else {
          _scores[category]!.intValue = 0;
        }
        break;

      case ScoreCategory.largeStraight:
        if (uniqueVals.containsAll([1, 2, 3, 4, 5]) 
            || uniqueVals.containsAll([2, 3, 4, 5, 6])) {
          _scores[category]!.intValue = 40;
        } else {
          _scores[category]!.intValue = 0;
        }
        break;

      case ScoreCategory.yahtzee:
        if (dice.length == 5 && uniqueVals.length == 1) {
          _scores[category]!.intValue = 50;
        } else {
          _scores[category]!.intValue = 0;
        }
        break;

      case ScoreCategory.chance:
        _scores[category]!.intValue = dice.sum;
        break;
      
      case ScoreCategory.totalScore:
        _scores[category]!.intValue = total;
    }
    notifyListeners();
  }
  }
}
