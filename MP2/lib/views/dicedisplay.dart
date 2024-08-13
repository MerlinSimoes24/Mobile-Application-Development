import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';

class YahtzeeDice extends StatefulWidget {
  final int dots;
  Dice dice;
  int index; 
  YahtzeeDice({super.key, required this.dots, required this.dice, required this.index});
  @override
  _YahtzeeDiceState createState() => _YahtzeeDiceState();
}
class _YahtzeeDiceState extends State<YahtzeeDice> {
@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      widget.dice.toggleHold(widget.index); // Toggle the "held" state immediately on tap
      setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: widget.dice.isHeld(widget.index)? Border.all(color: Colors.blue, width: 2.0): Border.all(color: Colors.transparent),
        ),
      child : Material(
      elevation: 4,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 72.0,
        height: 72.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 194, 190, 190),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
                children: dotsPlacement[widget.dots]!.map((alignment) {
                  return Align(
                    alignment: alignment,
                    child: const DiceDot(
                      color: Colors.black,
                    ),
                  );
                }).toList(),
              )
  
      ),
    ),
  ),
  );
  }
  static const dotsPlacement = {
    1 : [Alignment(0, 0)],
    2: [Alignment(-0.5, 0.5), Alignment(0.5, -0.5)],
    3: [Alignment(-0.5, 0.5), Alignment(0, 0), Alignment(0.5, -0.5)],
    4: [
      Alignment(-0.5, -0.5),
      Alignment(-0.5, 0.5),
      Alignment(0.5, 0.5),
      Alignment(0.5, -0.5)
    ],
    5: [
      Alignment(-0.5, -0.5),
      Alignment(-0.5, 0.5),
      Alignment(0, 0),
      Alignment(0.5, 0.5),
      Alignment(0.5, -0.5),
    ],
    6: [
      Alignment(-0.5, -0.5),
      Alignment(-0.5, 0),
      Alignment(-0.5, 0.5),
      Alignment(0.5, -0.5),
      Alignment(0.5, 0),
      Alignment(0.5, 0.5),
    ],
  };
}
class DiceDot extends StatelessWidget {
  final Color color;
  const DiceDot({required this.color, super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shadowColor: Colors.black38,
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        width: 5.0 * 2,
        height: 5.0 * 2,
      ),
    );
  }
}