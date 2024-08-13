import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

class Scorecarddisp extends StatefulWidget {
  ScoreCard scorecard;
  
  Dice dice;
  Scorecarddisp({Key? key, required this.scorecard, required this.dice}) : super(key: key);
  
  @override
  _ScoreCardState createState() => _ScoreCardState();
}
class _ScoreCardState extends State<Scorecarddisp> {
  Set<ScoreCategory> selectedCategories = {};

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 600,
      child: DataTable(
        columnSpacing: 10, // Set the spacing between columns
        dataRowHeight: 40.0,
        columns: const [
          DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),)),
          DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
        ],
        rows: ScoreCategory.values.map((category) {
          final score = widget.scorecard[category]!.intValue;
          bool isTapped = widget.scorecard[category]!.booleanValue;
          
          return DataRow(cells: [
            DataCell(
              GestureDetector(
                onTap: (widget.dice.currentRoll <= 3) && widget.scorecard.entryAdded
                    ? null
                    : () {
                        // Toggle the isTapped value for the specific category
                          widget.scorecard[category]!.booleanValue = !isTapped;
                          setState(() {
                          //Add the selected category to the set
                          selectedCategories.clear();
                          selectedCategories.add(category);
                          widget.scorecard.entryAdded = true;
                        });
                      },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isTapped ? Colors.blue : Colors.transparent,
                    ),
                  ),
                  child: Text(category.name.toString()),
                ),
              ),
            ),
            DataCell(Text(score.toString())),
          ]);
        }).toList(),
      ),
    );
  }
}
