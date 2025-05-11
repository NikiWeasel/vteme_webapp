import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/combined_regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/availible_time_selection.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/employee_reg_widget.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection/separation_widget.dart';
import 'package:vteme_tg_miniapp/main.dart';

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
    required this.selectRegsWithTime,
    required this.onBackPressed,
  });

  final List<Regulation> regs;
  final List<Appointment> appos;
  final Employee emp;

  final void Function(SelectedRegulationOption) selectRegsWithTime;

  final void Function() onBackPressed;

  @override
  State<TimeSelectionContent> createState() => _TimeSelectionContentState();
}

class _TimeSelectionContentState extends State<TimeSelectionContent> {
  final List<bool> _selectedTimeSelectionMode = <bool>[true, false];
  late List<DateTime> datesList;
  late CombinedRegulationsWithTimeOptions combinedBlock;
  List<RegulationWithTimeOptions> separateBlocks = [];

  int finalCost = 0;

  int finalDuration = 0;

  SelectedRegulationOption? selectedRegulationOption;
  List<Appointment> allAppos = [];

  @override
  void initState() {
    super.initState();
    allAppos = widget.appos;

    datesList =
        List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

    combinedBlock = CombinedRegulationsWithTimeOptions(
      regulations: widget.regs,
      dates: List.from(datesList),
      allAppointments: allAppos,
    );

    separateBlocks = widget.regs
        .map((reg) => RegulationWithTimeOptions(
              regulation: reg,
              dates: List.from(datesList),
              allAppointments: allAppos,
            ))
        .toList();

    print('separateBlocks.length');
    print(separateBlocks.length);

    countFinalVars();

    selectedRegulationWithTimeOptions.addListener(_onTimeChanged);
  }

  void regenerateTimeBlocks() {
    for (var block in separateBlocks) {
      block.updateDatesAndRegenerate(List.from(datesList));
    }
  }

  void _onTimeChanged() {
    if (selectedRegulationWithTimeOptions.value == null) return;

    // if (selectedRegulationWithTimeOptions.value is RegulationWithTimeOptions) {}
    // if (selectedRegulationWithTimeOptions.value
    //     is CombinedRegulationsWithTimeOptions) {}
    selectedRegulationOption = selectedRegulationWithTimeOptions.value;

    print('NOTIFIER');
  }

  void onContinueButton() {
    if (selectedRegulationOption == null ||
        !isTimeSelected(selectedRegulationOption!)) {
      showSnackBar(context: context, text: 'Не выбрано время');
      return;
    }
    widget.selectRegsWithTime(selectedRegulationOption!);

    selectedRegulationWithTimeOptions.value = null;
    //
    // widget.onSelected(selectedRegs);
  }

  bool isTimeSelected(SelectedRegulationOption selectedRegulationOption) {
    if (selectedRegulationOption is SelectedCombined) {
      var timeSlotsByDate = selectedRegulationOption.combined.timeSlotsByDate;
      int datesSelected = 0;
      for (var t in timeSlotsByDate) {
        // t.contains(element)
        if (t.any(
          (element) => element.isSelected,
        )) {
          datesSelected++;
        }
      }

      // print('timeSlotsByDate.length');
      // print(widget.regs.length);
      // print(datesSelected);
      return (1 == datesSelected);
    }

    if (selectedRegulationOption is SelectedSeparated) {
      final separatedRegsList = selectedRegulationOption.separated;

      int selectedCount = 0;

      print(separatedRegsList);

      for (var e in separatedRegsList) {
        final hasSelection = e.timeSlotsByDate.any(
          (slotList) => slotList.any((slot) => slot.isSelected),
        );
        if (hasSelection) {
          selectedCount++;
        }
      }
      print('widget.regs.length');
      print(widget.regs.length);
      print(selectedCount);
      return widget.regs.length == selectedCount;
    }

    return false;
  }

  void selectSeparatedTime(int index, RegulationWithTimeOptions selectedBlock) {
    var value = selectedRegulationWithTimeOptions.value;

    if (value == null) {
      selectedRegulationWithTimeOptions.value = SelectedSeparated([]);
      value = selectedRegulationWithTimeOptions.value;
    }

    if (value is SelectedSeparated) {
      // Убедимся, что список нужной длины
      while (value.separated.length < widget.regs.length) {
        value.separated.add(
          RegulationWithTimeOptions(
            regulation: widget.regs[value.separated.length],
            dates: [],
            allAppointments: [],
          ),
        );
      }

      // Обновляем текущий блок
      value.separated[index] = selectedBlock;

      // Если пользователь выбрал дату/время
      if (selectedBlock.isTimeSelected) {
        // 1. Вернуть все даты назад (сбросить до полного списка)
        for (int i = 0; i < value.separated.length; i++) {
          if (i == index) continue;

          value.separated[i].dates = List.from(datesList);
          value.separated[i]
              .updateDatesAndRegenerate(datesList); // <- вернуть все слоты
        }

        // 2. Удалить пересекающиеся слоты с новым выбором
        for (int i = 0; i < value.separated.length; i++) {
          if (i == index) continue;

          value.separated[i].removeOverlappingSlotsWith(selectedBlock);
        }

        setState(() {});
      }
    }
  }

  // void selectSeparatedTime(
  //     int index, RegulationWithTimeOptions regulationWithTimeOptions) {
  //   var value = selectedRegulationWithTimeOptions.value;
  //   if (value == null) {
  //     selectedRegulationWithTimeOptions.value = SelectedSeparated([]);
  //     value = selectedRegulationWithTimeOptions.value;
  //   }
  //   if (value is SelectedSeparated) {
  //     while (value.separated.length < widget.regs.length) {
  //       value.separated.add(
  //         RegulationWithTimeOptions(
  //           regulation: widget.regs[0],
  //           dates: [],
  //           allAppointments: [],
  //         ),
  //       );
  //     }
  //
  //     value.separated[index] = regulationWithTimeOptions;
  //     print(regulationWithTimeOptions.timeSlotsByDate);
  //
  //     late bool dateSelected;
  //     try {
  //       DateTime date = getDate(regulationWithTimeOptions.timeSlotsByDate);
  //       dateSelected = true;
  //     } catch (e) {
  //       dateSelected = false;
  //     }
  //
  //     if (dateSelected) {
  //       regenerateTimeBlocks();
  //       print(value.separated);
  //       print('select time');
  //
  //       List<RegulationWithTimeOptions> list = value.separated;
  //
  //       print(list);
  //       // list.removeAt(index);
  //       for (var e in list) {
  //         if (list[index] == e) continue;
  //         e.removeOverlappingSlotsWith(regulationWithTimeOptions);
  //       }
  //
  //       print(list);
  //       value.separated = list;
  //       setState(() {});
  //     }
  //   }
  // }

  void countFinalVars() {
    finalDuration = 0;
    finalCost = 0;

    for (var e in widget.regs) {
      setState(() {
        finalCost += e.cost;
        finalDuration += e.duration;
      });
    }
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
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: widget.onBackPressed,
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Выбор времени'),
          actions: [
            // IconButton(onPressed: reload, icon: const Icon(Icons.autorenew))
          ],
        ),
        bottomNavigationBar: Container(
          // height: 45,
          width: double.infinity,
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.secondary),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$finalCost руб',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                    Text(
                      '${widget.regs.length} услуг | $finalDuration минут',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: onContinueButton,
                    child: const Text('Продолжить'))
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: activeWidth,
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        constraints: const BoxConstraints(
                            minHeight: 40.0, minWidth: 80.0),
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
                              regulationWithTimeOptions: null,
                              addWeek: addWeek,
                              selectSeparatedTime: null,
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
                                    combinedRegulationsWithTimeOptions: null,
                                    regulationWithTimeOptions:
                                        separateBlocks[i],
                                    addWeek: addWeek,
                                    selectSeparatedTime: () {
                                      selectSeparatedTime(i, separateBlocks[i]);
                                    },
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
          ),
        ),
      );
    });
  }
}
