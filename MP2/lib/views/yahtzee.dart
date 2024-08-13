import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/views/dicedisplay.dart';
import 'package:mp2/views/rules.dart';
import 'package:mp2/views/scorecarddisp.dart';
class Yahtzee extends StatefulWidget {
  const Yahtzee({super.key});
  @override
  _YahtzeeState createState() => _YahtzeeState();
}
class _YahtzeeState extends State<Yahtzee> {
  late Dice dice;
  late ScoreCard scorecard;
  bool diceRendered = false;
  @override
  void initState() {
    super.initState();
    dice = Dice(5); // Initialize the dice with 5 dice.
    scorecard = ScoreCard();
  }
void rollDice() {
  if (dice.currentRoll < 3) {
    dice.roll();
    dice.currentRoll++;
    diceRendered = true;
    if (dice.currentTurn==0){
      dice.currentTurn=1;
    }
  } else {
    for (var i = 0; i < dice.values.length; i++) {
      if (dice.isHeld(i)) {
      dice.toggleHold(i);
    }
    }
    scorecard.entryAdded = false;
    // The user has used all 3 rolls, so increase the turn and reset the roll count.
    dice.currentTurn++;
    dice.currentRoll = 0;
    scorecard.isTapped = false;
    if (dice.currentTurn > 13) {
    showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Game Over'),
        content: Text('Congratulations! Your total score is ${scorecard.total}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              // Add any additional logic for restarting the game here
                setState(() {
                diceRendered = false;
                dice.clear();
                scorecard.clear();
                dice.currentTurn = 0;
                dice.currentRoll = 0;
                scorecard.entryAdded = false;
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      );
    },
  );
}
}
}
  @override
  Widget build(BuildContext context) {
    double screenWidth = 1280;
    double screenHeight = 720;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: const Color.fromARGB(255, 194, 190, 190),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
        children: [
          // Your YahtzeeDice widgets
          if(!diceRendered)
            Container(
            alignment: Alignment.center, // Center align the content
            color: const Color.fromARGB(255, 194, 190, 190),
            child: const Text(
              "Yahzteee",
              style: TextStyle(
                fontSize: 60, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Optionally make it bold
              ),
            ),
          ),
          if(!diceRendered)
          rules(),
          if (diceRendered)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final diceValue = dice.values[index];
              return YahtzeeDice(dots: diceValue, dice: dice, index: index);
            }),
          ),
          // Add a ListView for the scorecard
          if (diceRendered)
          Scorecarddisp(scorecard: scorecard, dice:dice),
        ],
		)
        ),
      ),
    floatingActionButton: Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      ListenableBuilder(
          listenable: scorecard, 
          builder: (BuildContext context,Widget? child) {
      return Column(
        children:[
      FloatingActionButton(
        onPressed: () {
          // Restart logic here
			      setState(() {
            diceRendered = false;
            dice.clear(); // Clear the dice values
            scorecard.clear(); // Clear the scorecard
            dice.currentTurn = 0; // Reset the current turn
            dice.currentRoll = 0; // Reset the current roll
            scorecard.isTapped = false;
            scorecard.entryAdded = false;
          });
        },
        child: const Row(
        children: [
          Icon(Icons.refresh),
          Text('replay', overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8,)), // Add the text here
        ],
      ),
      ),
      SizedBox(height: 16), // Add some spacing between the buttons
      FloatingActionButton(
        onPressed:() {
          if (dice.currentTurn <= 13) {
              setState(() {
              rollDice(); // Moved dice rolling logic to rollDice function
              diceRendered = true; // Set diceRendered to true when the dice are rendered
              for (var category in ScoreCategory.values) {
                scorecard.registerScore(category, dice.values);
              }
            });
          }
        },
        child: const Row(
        children: [
          Icon(Icons.play_arrow),
          Text('Play', overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 8,)), // Add the text here
        ],
      ),

      ),
      if(dice.currentTurn!=14)
      Text('Turn: ${dice.currentTurn} / 13', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text('Roll: ${dice.currentRoll} / 3', style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ]
      );
      }
      )
    ],
  ),
    );
  }
}
