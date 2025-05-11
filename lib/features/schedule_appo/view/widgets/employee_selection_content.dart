import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/category.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_tile.dart';

class EmployeeSelectionContent extends StatefulWidget {
  const EmployeeSelectionContent(
      {super.key,
      required this.employees,
      required this.allCategories,
      required this.onSelected,
      required this.onBackPressed,
      required this.selectedRegulations});

  final List<Employee> employees;
  final List<Regulation> selectedRegulations;
  final List<RegCategory> allCategories;
  final void Function(Employee) onSelected;

  final void Function() onBackPressed;

  @override
  State<EmployeeSelectionContent> createState() =>
      _EmployeeSelectionContentState();
}

class _EmployeeSelectionContentState extends State<EmployeeSelectionContent> {
  bool isTextFieldEmpty = true;
  late List<Employee> filteredEmployees;

  late List<Employee> _employees;

  late TextEditingController controller;

  late Map<String, String> catsMap = {};

  @override
  void initState() {
    super.initState();
    initEmployees();
    filteredEmployees = _employees;
    controller = TextEditingController();
    fillCatsMap();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void fillCatsMap() {
    catsMap.clear();
    for (var e in widget.allCategories) {
      catsMap[e.id!] = e.name;
    }
  }

  String getCatNames(List<String> cats) {
    String catNames = '';
    for (var c in cats) {
      if (catsMap[c] == null) continue;
      catNames += '${catsMap[c]!}, ';
    }
    return catNames.length > 2
        ? catNames.substring(0, catNames.length - 2)
        : catNames;
  }

  void initEmployees() {
    _employees = [];
    for (var e in widget.employees) {
      if (isSubset(getRegsIdsFromRegList(widget.selectedRegulations),
          getRegsIdsFromCatIds(e.categoryIds, widget.allCategories))) {
        _employees.add(e);
      }
    }
  }

  void deleteString() {
    controller.clear();
    setState(() {
      filteredEmployees = _employees;
    });
  }

  void onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        isTextFieldEmpty = true;
        filteredEmployees = _employees;
      });
    } else {
      setState(() {
        isTextFieldEmpty = false;
        filterEmployees(toSearchString(value));
      });
    }
  }

  void filterEmployees(String search) {
    setState(() {
      filteredEmployees = _employees
          .where(
            (e) =>
                ('${toSearchString(e.name)} ${toSearchString(e.surname)} ${toSearchString(getCatNames(e.categoryIds))}')
                    .contains(search),
          )
          .toList();
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
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12))),
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                  ),
                  child: TextField(
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
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
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var e in filteredEmployees)
                      EmployeeTile(
                          employee: e,
                          catNames: getCatNames(e.categoryIds),
                          onTap: () {
                            widget.onSelected(e);
                          })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
