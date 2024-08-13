import 'package:flutter/material.dart';
import 'dart:math';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/views/DiceDisplay.dart';
import 'package:mp2/views/ScoreCategoryPicker.dart';

class Yahtzee extends StatelessWidget {
  const Yahtzee({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Single-Player Yahtzee Game', style: TextStyle(color: Colors.red, fontSize: 23)),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: const Padding(padding: EdgeInsets.all(16.0), child: YahtzeeGame()),
        backgroundColor: Colors.lightBlue.shade100, // Set background color
      ),
    );
  }
}

class YahtzeeGame extends StatefulWidget {
  const YahtzeeGame({Key? key}) : super(key: key);

  @override
  YahtzeeGameState createState() => YahtzeeGameState();
}

class YahtzeeGameState extends State<YahtzeeGame> {
  List<int?> boxValues = List.filled(5, null);
  List<bool> isSelected = List.filled(5, false);
  int rollCount = 1;
  Random random = Random();
  ScoreCard scoreCard = ScoreCard();

  void rollDice() {
    if (rollCount <= 3) {
      setState(() {
        for (int i = 0; i < 5; i++) {
          if (!isSelected[i]) {
            boxValues[i] = random.nextInt(6) + 1;
          }
        }
        rollCount++;
      });
    }
  }

  void toggleSelection(int index) {
    setState(() {
      isSelected[index] = !isSelected[index];
    });
  }

  void resetGame() {
    setState(() {
      scoreCard.clear();
      rollCount = 1;
      boxValues = List.filled(5, null);
      isSelected = List.filled(5, false);
    });
  }

  void pickCategory(ScoreCategory category) {
    setState(() {
      List<int> dice = boxValues.where((value) => value != null).cast<int>().toList();
      scoreCard.registerScore(category, dice);
      boxValues = List.filled(5, null);
      isSelected = List.filled(5, false);
      rollCount = 1;
    });

    // Check if the game is completed after picking a category
    if (scoreCard.completed) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('Congratulations! Your total score is ${scoreCard.total}'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  resetGame(); // Reset the game for a new round
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(5, (index) => DiceDisplay(
                  value: boxValues[index] ?? 0,
                  isSelected: isSelected[index],
                  onTap: () => toggleSelection(index),
                )),
              ),
             Padding(
                 padding: const EdgeInsets.symmetric(vertical: 20.0),
                 child: ElevatedButton(
                 onPressed: rollCount <= 3 ? rollDice : null,
                 // Update the button text to display "Roll Dice: X" where X starts from 0 and increments upon each roll
                 child: Text('Roll Dice : ${rollCount - 1}'), // Subtract 1 to start count from 0
               ),
               ),

              // ScoreCategoryPicker and Ongoing Score Display...
              ScoreCategoryPicker(
                scoreCard: scoreCard,
                onCategoryPick: pickCategory,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text('Ongoing Score: ${scoreCard.total}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}