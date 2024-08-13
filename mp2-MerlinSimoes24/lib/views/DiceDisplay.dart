import 'package:flutter/material.dart';

class DiceDisplay extends StatelessWidget {
  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  const DiceDisplay({
    Key? key,
    required this.value,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData diceIcon;
    switch (value) {
      case 1:
        diceIcon = Icons.looks_one;
        break;
      case 2:
        diceIcon = Icons.looks_two;
        break;
      case 3:
        diceIcon = Icons.looks_3;
        break;
      case 4:
        diceIcon = Icons.looks_4;
        break;
      case 5:
        diceIcon = Icons.looks_5;
        break;
      case 6:
        diceIcon = Icons.looks_6;
        break;
      default:
        diceIcon = Icons.help_outline; // Icon to show when no value is set
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 81,
        height: 81,
        margin: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[200] : Colors.white, // Highlight selected dice
          border: Border.all(color: isSelected ? Colors.green : Colors.grey),
          borderRadius: BorderRadius.circular(10), // Optional: adds rounded corners
        ),
        child: Center(
          child: Icon(diceIcon, size: 48), // Display the icon representing the dice value
        ),
      ),
    );
  }
}
