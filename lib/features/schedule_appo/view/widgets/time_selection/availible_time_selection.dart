import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/combined_regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/date_button.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/time_button.dart';

class AvailableTimeSelection extends StatefulWidget {
  const AvailableTimeSelection({
    super.key,
    required this.regulationWithTimeOptions,
    required this.combinedRegulationsWithTimeOptions,
    required this.addWeek,
  });

  final CombinedRegulationsWithTimeOptions combinedRegulationsWithTimeOptions;
  final List<RegulationWithTimeOptions> regulationWithTimeOptions;
  final void Function() addWeek;

  @override
  State<AvailableTimeSelection> createState() => _AvailableTimeSelectionState();
}

class _AvailableTimeSelectionState extends State<AvailableTimeSelection> {
  late int selectedDateIndex;

  @override
  void initState() {
    selectedDateIndex = 0;
    super.initState();
  }

  void selectDate(int index) {
    setState(() {
      selectedDateIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dates = widget.combinedRegulationsWithTimeOptions.dates;
    final selectedDate = dates[selectedDateIndex];
    final timeOptions =
        widget.combinedRegulationsWithTimeOptions.timeSlotsByDate;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < dates.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: DateButton(
                      dateTime: dates[i],
                      isSelected: selectedDateIndex == i,
                      index: i,
                      onSelected: selectDate,
                    ),
                  ),
                IconButton(
                  onPressed: widget.addWeek,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < timeOptions[selectedDateIndex].length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: TimeButton(
                      dateTime: timeOptions[selectedDateIndex][i].time,
                      isSelected: timeOptions[selectedDateIndex][i].isSelected,
                      onSelected: () {
                        setState(() {
                          widget.combinedRegulationsWithTimeOptions
                              .selectSlot(selectedDateIndex, i);
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
