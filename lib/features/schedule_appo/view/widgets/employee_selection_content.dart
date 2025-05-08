import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_tile.dart';

class EmployeeSelectionContent extends StatefulWidget {
  const EmployeeSelectionContent(
      {super.key,
      required this.employees,
      required this.onSelected,
      required this.onBackPressed});

  final List<Employee> employees;
  final void Function(Employee) onSelected;

  final void Function() onBackPressed;

  @override
  State<EmployeeSelectionContent> createState() =>
      _EmployeeSelectionContentState();
}

class _EmployeeSelectionContentState extends State<EmployeeSelectionContent> {
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

  void reload() {
    context.read<LocalEmployeesBloc>().add(FetchAllEmployeesData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: widget.onBackPressed,
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Выбор специалиста'),
        actions: [
          IconButton(onPressed: reload, icon: const Icon(Icons.autorenew))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: TextField(
                    controller: controller,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        labelText: 'Поиск по имени, типам услуг',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: isTextFieldEmpty
                            ? null
                            : IconButton(
                                onPressed: deleteString,
                                icon: const Icon(Icons.close),
                              )),
                    onChanged: onChanged,
                  )),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  for (var e in filteredEmployees)
                    EmployeeTile(
                        employee: e,
                        onTap: () {
                          widget.onSelected(e);
                        })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
