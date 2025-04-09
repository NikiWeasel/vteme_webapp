import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_web_app/telegram_web_app.dart' as tg;
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/appo_type_widget.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_selection_content.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, this.employee, this.service});

  final Employee? employee;
  final Regulation? service;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  tg.BackButton get backButton => tg.TelegramWebApp.instance.backButton;

  @override
  void initState() {
    backButton.onClick(onBackPressed);
    backButton.show();
    super.initState();
  }

  @override
  void dispose() {
    backButton.hide();
    backButton.offClick(onBackPressed);
    super.dispose();
  }

  void onBackPressed() {
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
        builder: (context, regState) {
          return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
            builder: (context, empState) {
              return Scaffold(
                body: widget.service != null
                    ? Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: activeWidth < 800
                              ? constraints.maxWidth
                              : constraints.maxWidth / 2,
                          child: EmployeeSelectionContent(
                            employees: (empState is LocalEmployeesLoaded)
                                ? empState.employees
                                : [],
                          ),
                        ),
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
                              AppoTypeWidget(
                                  text: 'Выбрать специалиста', onTap: () {}),
                            ],
                          )
                        ],
                      ),
              );
            },
          );
        },
      );
    });
  }
}
