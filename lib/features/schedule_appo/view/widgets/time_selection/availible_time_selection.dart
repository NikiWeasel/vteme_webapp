import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/date_button.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/time_button.dart';

class AvailableTimeSelection extends StatefulWidget {
  const AvailableTimeSelection(
      {super.key,
      required this.freeSlots,
      required this.dateBoolList,
      required this.selectSlot,
      required this.resetDateBoolList,
      required this.regIndex,
      required this.selectSlotDifferentTime});

  final List<List<DateTime>> freeSlots;
  final List<List<bool>> dateBoolList;
  final void Function(int, int)? selectSlot;
  final void Function(int, int, int)? selectSlotDifferentTime;

  final void Function() resetDateBoolList;
  final int regIndex;

  @override
  State<AvailableTimeSelection> createState() => _AvailableTimeSelectionState();
}

class _AvailableTimeSelectionState extends State<AvailableTimeSelection> {
  late List<bool> boolList;

  int trueIndex = 0;

  @override
  void initState() {
    boolList = List.generate(
      7,
      (index) {
        if (index == 0) return true;
        return false;
      },
    );
    super.initState();
  }

  void selectDate(int i) {
    // widget.resetDateBoolList();
    boolList = List.generate(
      7,
      (index) => false,
    );
    setState(() {
      boolList[i] = true;
      trueIndex = i;
    });
    print(trueIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < widget.freeSlots.length; i++) ...[
                  DateButton(
                    dateTime: widget.freeSlots[i][0],
                    isSelected: boolList[i],
                    index: i,
                    onSelected: selectDate,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0;
                    i < widget.freeSlots[trueIndex].length;
                    i++) ...[
                  TimeButton(
                    dateTime: widget.freeSlots[trueIndex][i],
                    isSelected: widget.dateBoolList[trueIndex][i],
                    onSelected: () {
                      if (widget.selectSlot == null) {
                        widget.selectSlotDifferentTime!(
                            trueIndex, i, widget.regIndex);
                      } else {
                        widget.selectSlot!(
                          trueIndex,
                          i,
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                ]
              ],
            ),
          ),
        )
        // Text(''),
      ],
    );
  }
}
