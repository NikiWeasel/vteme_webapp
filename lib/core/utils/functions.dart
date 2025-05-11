import 'package:flutter/material.dart';
import 'package:translit/translit.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/time_slot_option.dart';

List<DateTime> getAvailableTimeSlots({
  required List<Appointment> appos,
  required List<Regulation> regulations,
  required DateTime day,
}) {
  const workStartHour = 10;
  const workEndHour = 20;

  final totalDurationMinutes = regulations.fold<int>(
    0,
    (sum, reg) => sum + reg.duration,
  );
  final duration = Duration(minutes: totalDurationMinutes);

  final appointmentsOnDay = appos
      .where((a) =>
          a.date.year == day.year &&
          a.date.month == day.month &&
          a.date.day == day.day)
      .toList();

  appointmentsOnDay.sort((a, b) => a.date.compareTo(b.date));

  final dayStart = DateTime(day.year, day.month, day.day, workStartHour);
  final dayEnd = DateTime(day.year, day.month, day.day, workEndHour);

  final freeSlots = <DateTime>[];
  DateTime current = dayStart;

  for (final appointment in appointmentsOnDay) {
    final start = appointment.date;
    final end = start.add(Duration(minutes: appointment.duration));

    if (start.difference(current) >= duration) {
      DateTime slot = current;
      while (slot.add(duration).isBefore(start) ||
          slot.add(duration).isAtSameMomentAs(start)) {
        freeSlots.add(slot);
        slot = slot.add(duration);
      }
    }

    if (end.isAfter(current)) {
      current = end;
    }
  }

  if (dayEnd.difference(current) >= duration) {
    DateTime slot = current;
    while (slot.add(duration).isBefore(dayEnd) ||
        slot.add(duration).isAtSameMomentAs(dayEnd)) {
      freeSlots.add(slot);
      slot = slot.add(duration);
    }
  }

  // print(appos);
  // print(DateTime.now().toString());
  // print(DateTime.now().toString());
  // print(freeSlots);
  return freeSlots;
}

void showSnackBar(
    {required BuildContext context, required String text, Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
      child: Text(text),
    ),
    duration: duration ?? const Duration(seconds: 1, milliseconds: 500),
  ));
}

DateTime getDate(List<List<TimeSlotOption>> timeSlotsByDate) {
  // regs.timeSlotsByDate;
  late DateTime date;
  List<TimeSlotOption> timeList = [];
  for (var e in timeSlotsByDate) {
    timeList.addAll(e
        .where(
          (element) => element.isSelected,
        )
        .toList());
  }
  date = timeList.single.time;
  return date;
}

String toSearchString(String source) {
  return unTranslit(source.toLowerCase());
}

String unTranslit(String source) {
  return Translit().unTranslit(source: source);
}
