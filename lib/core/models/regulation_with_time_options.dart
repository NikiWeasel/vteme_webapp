import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
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
}
