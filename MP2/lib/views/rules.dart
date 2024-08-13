
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class rules extends StatelessWidget{
  @override
  Widget build(Object context) {
    // TODO: implement build
    return Container(
  padding: EdgeInsets.all(50), // Adjust the padding as needed
  width: 700,
  decoration: BoxDecoration(
    color: Colors.white, // Set the background color of the container
    borderRadius: BorderRadius.circular(10), // Optionally add rounded corners
  ),
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Align the text to the left
    children: [
      Text(
        'Yahtzee Rules:',
        style: TextStyle(
          fontSize: 20, // Adjust the font size as needed
          fontWeight: FontWeight.bold, // Optionally make it bold
        ),
      ),
      Text(
        '1. Players take turns rolling all five dice.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '2. Each player can roll the dice up to three times in a turn.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '3. After each roll, the player can choose which dice to keep and which to re-roll.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '4. The player must choose a scoring category and record their score based on the final dice combination.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '5. The game consists of 13 rounds, one for each category on the scorecard.',
        style: TextStyle(fontSize: 16),
      ),
      SizedBox(height: 16), // Add some spacing
      Text(
        'Yahtzee Score Categories:',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        '1. Ones - Sixes: Score the sum of all dice showing the specified number.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '2. Three of a Kind: At least three dice showing the same number. Score the sum of all dice.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '3. Four of a Kind: At least four dice showing the same number. Score the sum of all dice.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '4. Full House: Three dice of one number and two dice of another number. Score 25 points.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '5. Small Straight: Four consecutive numbers (e.g., 1-2-3-4). Score 30 points.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '6. Large Straight: Five consecutive numbers (e.g., 1-2-3-4-5). Score 40 points.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '7. Yahtzee: All five dice showing the same number. First Yahtzee scores 50 points.',
        style: TextStyle(fontSize: 16),
      ),
      Text(
        '8. Chance: Score the sum of all five dice.',
        style: TextStyle(fontSize: 16),
      ),
    ],
  ),
);
  }

}