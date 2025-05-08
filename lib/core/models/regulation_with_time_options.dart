import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/time_slot_option.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';

class RegulationWithTimeOptions {
  final Regulation regulation;
  final List<Appointment> allAppointments;
  List<DateTime> dates;
  late List<List<TimeSlotOption>> timeSlotsByDate;

  RegulationWithTimeOptions({
    required this.regulation,
    required this.dates,
    required this.allAppointments,
  }) {
    _initialize();
  }

  void _initialize() {
    timeSlotsByDate = dates
        .map((date) => getAvailableTimeSlots(
              appos: allAppointments,
              regulations: [regulation],
              day: date,
            ).map((time) => TimeSlotOption(time: time)).toList())
        .toList();
  }

  void addDates(List<DateTime> newDates) {
    dates.addAll(newDates);
    final newSlots = newDates
        .map((date) => getAvailableTimeSlots(
              appos: allAppointments,
              regulations: [regulation],
              day: date,
            ).map((time) => TimeSlotOption(time: time)).toList())
        .toList();

    timeSlotsByDate.addAll(newSlots);
  }

  void selectSlot(int dateIndex, int slotIndex) {
    resetSelection();
    timeSlotsByDate[dateIndex][slotIndex].isSelected = true;
  }

  void resetSelection() {
    for (var dateSlots in timeSlotsByDate) {
      for (var slot in dateSlots) {
        slot.isSelected = false;
      }
    }
  }

  DateTime _slotEnd(DateTime start) {
    return start.add(Duration(minutes: regulation.duration));
  }

  bool _rangesOverlap(
      DateTime aStart, DateTime aEnd, DateTime bStart, DateTime bEnd) {
    return aStart.isBefore(bEnd) && aEnd.isAfter(bStart);
  }

  void removeOverlappingSlotsWith(RegulationWithTimeOptions other) {
    for (int i = 0; i < dates.length; i++) {
      final mySlots = timeSlotsByDate[i];

      for (int j = 0; j < other.dates.length; j++) {
        if (dates[i] != other.dates[j]) continue;

        final otherSlots = other.timeSlotsByDate[j];
        final selected = otherSlots.where((e) => e.isSelected).toList();
        if (selected.isEmpty) continue;

        for (var sel in selected) {
          final selStart = sel.time;
          final selEnd = other._slotEnd(sel.time);

          mySlots.removeWhere((slot) {
            final slotStart = slot.time;
            final slotEnd = _slotEnd(slot.time);
            return _rangesOverlap(slotStart, slotEnd, selStart, selEnd);
          });
        }
      }
    }
  }

  bool get isTimeSelected {
    for (final daySlots in timeSlotsByDate) {
      for (final slot in daySlots) {
        if (slot.isSelected) return true;
      }
    }
    return false;
  }

  void updateDatesAndRegenerate(List<DateTime> newDates) {
    // Сохраняем все ранее выбранные времена
    final selectedTimes = <DateTime>{};
    for (final slots in timeSlotsByDate) {
      for (final slot in slots) {
        if (slot.isSelected) {
          selectedTimes.add(slot.time);
        }
      }
    }

    // Обновляем даты и пересоздаём слоты
    dates = newDates;
    timeSlotsByDate = dates
        .map((date) => getAvailableTimeSlots(
              appos: allAppointments,
              regulations: [regulation],
              day: date,
            )
                .map((time) => TimeSlotOption(
                      time: time,
                      isSelected:
                          selectedTimes.any((t) => t.isAtSameMomentAs(time)),
                    ))
                .toList())
        .toList();
  }

  @override
  String toString() {
    return '($regulation $dates)';
  }
}
