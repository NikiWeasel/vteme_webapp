import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_tile.dart';

class EmployeeSelectionContent extends StatefulWidget {
  const EmployeeSelectionContent({super.key, required this.employees});

  final List<Employee> employees;

  @override
  State<EmployeeSelectionContent> createState() =>
      _EmployeeSelectionContentState();
}

class _EmployeeSelectionContentState extends State<EmployeeSelectionContent> {
  //TODO Скорее всего лучше будет несколько экранов сделать для более простой навигации назад. А МОЖЕТ И НЕТ
  bool isTextFieldEmpty = true;
  late List<Employee> filteredEmployees;

  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    filteredEmployees = widget.employees;
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void deleteString() {
    controller.clear();
    // controller.text = '';

    setState(() {
      filteredEmployees = widget.employees;
    });
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        isTextFieldEmpty = true;
        filteredEmployees = widget.employees;
      });
    } else {
      setState(() {
        isTextFieldEmpty = false;
        filterEmployees(value);
      });
    }
  }

  void filterEmployees(String search) {
    setState(() {
      filteredEmployees = filteredEmployees
          .where(
            (e) => ('${e.name} ${e.surname} ${e.categoryIds.join(' ')}')
                .contains(search),
          )
          .toList(); //TODO Разобраться с КАТЕГОРИЯМИИИИИИИИИИИИИИИИИ
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 45,
            child: TextField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  hintText: 'Поиск по имени, типам услуг',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffix: isTextFieldEmpty
                      ? null
                      : IconButton(
                          onPressed: deleteString,
                          icon: const Icon(Icons.close),
                        )),
              onChanged: onChanged,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              for (var e in filteredEmployees)
                EmployeeTile(
                    employee: e,
                    onTap: () {
                      //TODO СДЕЛАТЬ
                    })
            ],
          ),
        )
      ],
    );
  }
}
