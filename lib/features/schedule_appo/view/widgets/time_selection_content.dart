import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/availible_time_selection.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/employee_reg_widget.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/separation_widget.dart';

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
  const TimeSelectionContent(
      {super.key, required this.regs, required this.appos, required this.emp});

  final List<Regulation> regs;
  final List<Appointment> appos;
  final Employee emp;

  @override
  State<TimeSelectionContent> createState() => _TimeSelectionContentState();
}

class _TimeSelectionContentState extends State<TimeSelectionContent> {
  final List<bool> _selectedTimeSelectionMode = <bool>[true, false];

  List<List<DateTime>> freeSlots = [];

  List<List<bool>> dateBoolList = [];

  late List<DateTime> datesList;

  List<List<List<bool>>> dateBoolListDifferentTime = [];

  @override
  void initState() {
    datesList = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index)),
    );
    resetDateBoolList();
    resetDateBoolListDifferentTime();
    setFreeSlots();
    super.initState();
  }

  void setFreeSlots() {
    for (int i = 0; i < datesList.length; i++) {
      freeSlots.add(getAvailableTimeSlots(
        appos: widget.appos,
        day: datesList[i],
        regulations: widget.regs,
      ));
    }
  }

  void selectSlot(int index1, int index2) {
    resetDateBoolList();
    setState(() {
      dateBoolList[index1][index2] = true;
    });
  }

  void selectSlotDifferentTime(int index1, int index2, int regIndex) {
    // resetDateBoolListDifferentTime();
    dateBoolListDifferentTime[regIndex] =
        List.generate(7, (_) => List.generate(7, (_) => false));
    setState(() {
      dateBoolListDifferentTime[regIndex][index1][index2] = true;
    });
  }

  void resetDateBoolList() {
    setState(() {
      dateBoolList = List.generate(7, (_) => List.generate(7, (_) => false));
    });
  }

  void resetDateBoolListDifferentTime() {
    setState(() {
      dateBoolListDifferentTime = List.generate(widget.regs.length,
          (_) => List.generate(7, (_) => List.generate(7, (_) => false)));
    });
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    return LayoutBuilder(builder: (context, constraints) {
      return Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: activeWidth < 800
              ? constraints.maxWidth
              : constraints.maxWidth / 2,
          child: Column(
            children: [
              widget.regs.length != 1
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0;
                                i < _selectedTimeSelectionMode.length;
                                i++) {
                              _selectedTimeSelectionMode[i] = i == index;
                            }
                            resetDateBoolListDifferentTime();
                            resetDateBoolList();
                          });
                        },
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        constraints: const BoxConstraints(
                            minHeight: 40.0, minWidth: 80.0),
                        isSelected: _selectedTimeSelectionMode,
                        children: shedMode,
                      ),
                    )
                  : const SizedBox.shrink(),
              if (_selectedTimeSelectionMode[0]) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (var e in widget.regs) ...[
                          EmployeeRegWidget(emp: widget.emp, reg: e),
                          const SeparationWidget(),
                        ],
                        const SizedBox(
                          height: 8,
                        ),
                        AvailableTimeSelection(
                          freeSlots: freeSlots,
                          dateBoolList: dateBoolList,
                          selectSlot: selectSlot,
                          resetDateBoolList: resetDateBoolList,
                          regIndex: 0,
                          selectSlotDifferentTime: null,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                )
              ] else ...[
                Column(
                  children: [
                    for (int i = 0; i < widget.regs.length; i++) ...[
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              EmployeeRegWidget(
                                  emp: widget.emp, reg: widget.regs[i]),
                              const SeparationWidget(),
                              AvailableTimeSelection(
                                freeSlots: freeSlots,
                                dateBoolList: dateBoolListDifferentTime[i],
                                selectSlotDifferentTime:
                                    selectSlotDifferentTime,
                                resetDateBoolList:
                                    resetDateBoolListDifferentTime,
                                regIndex: i,
                                selectSlot: null,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                    ]
                  ],
                ),
              ]
            ],
          ),
        ),
      );
    });
  }
}
