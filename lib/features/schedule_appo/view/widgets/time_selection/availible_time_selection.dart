import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/combined_regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/date_button.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/time_button.dart';
import 'package:vteme_tg_miniapp/main.dart';

class AvailableTimeSelection extends StatefulWidget {
  const AvailableTimeSelection({
    super.key,
    required this.regulationWithTimeOptions,
    required this.combinedRegulationsWithTimeOptions,
    required this.addWeek,
    required this.selectSeparatedTime,
  });

  final CombinedRegulationsWithTimeOptions? combinedRegulationsWithTimeOptions;
  final RegulationWithTimeOptions? regulationWithTimeOptions;
  final void Function() addWeek;
  final void Function()? selectSeparatedTime;

  @override
  State<AvailableTimeSelection> createState() => _AvailableTimeSelectionState();
}

class _AvailableTimeSelectionState extends State<AvailableTimeSelection> {
  late int selectedDateIndex;

  List<RegulationWithTimeOptions> separatedRegsList = [];

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
    // final selectedDate = combinedRegsDates[selectedDateIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Builder(builder: (context) {
              if (widget.combinedRegulationsWithTimeOptions != null) {
                final combinedRegsDates =
                    widget.combinedRegulationsWithTimeOptions!.dates;

                return Row(
                  children: [
                    for (int i = 0; i < combinedRegsDates.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: DateButton(
                          dateTime: combinedRegsDates[i],
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
                );
              }
              if (widget.regulationWithTimeOptions != null) {
                final separatedRegsDates =
                    widget.regulationWithTimeOptions!.dates;
                return Row(
                  children: [
                    for (int i = 0; i < separatedRegsDates.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: DateButton(
                          dateTime: separatedRegsDates[i],
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
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Builder(builder: (context) {
              if (widget.combinedRegulationsWithTimeOptions != null) {
                final combinedRegsTimeOptions =
                    widget.combinedRegulationsWithTimeOptions!.timeSlotsByDate;
                return Row(
                  children: [
                    for (int i = 0;
                        i < combinedRegsTimeOptions[selectedDateIndex].length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TimeButton(
                          dateTime: combinedRegsTimeOptions[selectedDateIndex]
                                  [i]
                              .time,
                          isSelected: combinedRegsTimeOptions[selectedDateIndex]
                                  [i]
                              .isSelected,
                          onSelected: () {
                            setState(() {
                              widget.combinedRegulationsWithTimeOptions!
                                  .selectSlot(selectedDateIndex, i);
                            });
                            selectedRegulationWithTimeOptions.value =
                                SelectedCombined(
                                    widget.combinedRegulationsWithTimeOptions!);
                          },
                        ),
                      ),
                  ],
                );
              }
              if (widget.regulationWithTimeOptions != null) {
                final separatedRegsTimeOptions =
                    widget.regulationWithTimeOptions!.timeSlotsByDate;
                return Row(
                  children: [
                    for (int i = 0;
                        i < separatedRegsTimeOptions[selectedDateIndex].length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: TimeButton(
                          dateTime: separatedRegsTimeOptions[selectedDateIndex]
                                  [i]
                              .time,
                          isSelected:
                              separatedRegsTimeOptions[selectedDateIndex][i]
                                  .isSelected,
                          onSelected: () {
                            setState(() {
                              widget.regulationWithTimeOptions!
                                  .selectSlot(selectedDateIndex, i);
                            });
                            widget.selectSeparatedTime!();
                          },
                        ),
                      ),
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
        ),
      ],
    );
  }
}
