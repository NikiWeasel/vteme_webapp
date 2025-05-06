import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/combined_regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/regulation_with_time_options.dart';
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
  const TimeSelectionContent({
    super.key,
    required this.regs,
    required this.appos,
    required this.emp,
  });

  final List<Regulation> regs;
  final List<Appointment> appos;
  final Employee emp;

  @override
  State<TimeSelectionContent> createState() => _TimeSelectionContentState();
}

class _TimeSelectionContentState extends State<TimeSelectionContent> {
  final List<bool> _selectedTimeSelectionMode = <bool>[true, false];
  late List<DateTime> datesList;
  late CombinedRegulationsWithTimeOptions combinedBlock;
  List<RegulationWithTimeOptions> separateBlocks = [];

  @override
  void initState() {
    super.initState();
    datesList =
        List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

    combinedBlock = CombinedRegulationsWithTimeOptions(
      regulations: widget.regs,
      dates: List.from(datesList),
      allAppointments: widget.appos,
    );

    separateBlocks = widget.regs
        .map((reg) => RegulationWithTimeOptions(
              regulation: reg,
              dates: List.from(datesList),
              allAppointments: widget.appos,
            ))
        .toList();
  }

  void addWeek() {
    if (datesList.length > 28) {
      showSnackBar(
        context: context,
        text: 'Записаться можно только на следующие 4 недели от текущего дня',
      );
      return;
    }

    final lastDate = datesList.last;
    final newWeek =
        List.generate(7, (index) => lastDate.add(Duration(days: index + 1)));

    setState(() {
      datesList.addAll(newWeek);
      combinedBlock.addDates(
        newWeek,
      );
      for (final block in separateBlocks) {
        block.addDates(
          newWeek,
        );
      }
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
              if (widget.regs.length > 1)
                Padding(
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
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    constraints:
                        const BoxConstraints(minHeight: 40.0, minWidth: 80.0),
                    isSelected: _selectedTimeSelectionMode,
                    children: shedMode,
                  ),
                ),
              if (_selectedTimeSelectionMode[0]) // Объединенное расписание
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        for (var reg in widget.regs) ...[
                          EmployeeRegWidget(emp: widget.emp, reg: reg),
                          const SeparationWidget(),
                        ],
                        const SizedBox(height: 8),
                        AvailableTimeSelection(
                          combinedRegulationsWithTimeOptions: combinedBlock,
                          regulationWithTimeOptions: separateBlocks,
                          addWeek: addWeek,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                )
              else // Раздельное расписание
                Column(
                  children: [
                    for (int i = 0; i < separateBlocks.length; i++)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              EmployeeRegWidget(
                                  emp: widget.emp,
                                  reg: separateBlocks[i].regulation),
                              const SeparationWidget(),
                              AvailableTimeSelection(
                                combinedRegulationsWithTimeOptions:
                                    combinedBlock,
                                regulationWithTimeOptions: separateBlocks,
                                addWeek: addWeek,
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
