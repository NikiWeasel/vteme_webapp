import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<Widget> shedMode = <Widget>[
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Text('Последовательно'),
  ),
  Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.0),
    child: Text('В разное время'),
  )
];

class TimeSelectionContent extends StatefulWidget {
  const TimeSelectionContent({super.key});

  @override
  State<TimeSelectionContent> createState() => _TimeSelectionContentState();
}

class _TimeSelectionContentState extends State<TimeSelectionContent> {
  final List<bool> _selectedFruits = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (int index) {
            setState(() {
              // The button that is tapped is set to true, and the others to false.
              for (int i = 0; i < _selectedFruits.length; i++) {
                _selectedFruits[i] = i == index;
              }
            });
          },
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          constraints: const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
          isSelected: _selectedFruits,
          children: shedMode,
        ),
      ],
    );
  }
}
