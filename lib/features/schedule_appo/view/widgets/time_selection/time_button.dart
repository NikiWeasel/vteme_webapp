import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeButton extends StatelessWidget {
  const TimeButton({
    super.key,
    required this.dateTime,
    required this.isSelected,
    required this.onSelected,
  });

  final DateTime dateTime;
  final bool isSelected;
  final void Function() onSelected;

  // final int index;

  String formatTime(DateTime date) {
    final formatted = DateFormat('HH:mm').format(date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () {
        onSelected();
      },
      child: Container(
          width: 75,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                formatTime(dateTime),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          )),
    );
  }
}
