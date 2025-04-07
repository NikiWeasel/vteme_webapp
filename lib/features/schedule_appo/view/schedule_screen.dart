import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/appo_type_widget.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_selection_content.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key, this.employee, this.service});

  final Employee? employee;
  final Regulation? service;

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: true
            ? BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
                builder: (context, state) {
                  return Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: activeWidth < 800
                          ? constraints.maxWidth
                          : constraints.maxWidth / 2,
                      child: EmployeeSelectionContent(
                        employees: (state is LocalEmployeesLoaded)
                            ? state.employees
                            : [],
                      ),
                    ),
                  );
                },
              )
            : Column(
                children: [
                  const Text('Новая запись'),
                  Wrap(
                    children: [
                      AppoTypeWidget(
                          text: 'Выбрать услуги',
                          onTap: () {
                            // context.pu
                          }),
                      AppoTypeWidget(text: 'Выбрать специалиста', onTap: () {}),
                    ],
                  )
                ],
              ),
      );
    });
  }
}
