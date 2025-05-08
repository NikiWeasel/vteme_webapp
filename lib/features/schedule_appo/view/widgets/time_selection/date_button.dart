import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatelessWidget {
  const DateButton(
      {super.key,
      required this.dateTime,
      required this.isSelected,
      required this.index,
      required this.onSelected});

  final DateTime dateTime;
  final bool isSelected;
  final void Function(int) onSelected;

  final int index;

  String formatWeekday(DateTime date) {
    String weekday = DateFormat.EEEE('ru').format(date);
    return weekday;
  }

  String formatMonth(DateTime date) {
    String month = DateFormat.MMMM('ru').format(date);
    return month;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: () {
        onSelected(index);
      },
      child: Container(
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '${dateTime.day} ${formatWeekday(dateTime)} ',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondary),
                ),
                //Число + день недели
                Text(
                  formatMonth(dateTime),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSecondary),
                ),
                //Месяц
              ],
            ),
          )),
    );
  }
}
