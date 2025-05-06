import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_web_app/telegram_web_app.dart' as tg;
import 'package:vteme_tg_miniapp/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/appo_type_widget.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_selection_content.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/reg_selection_content.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection_content.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, this.employee, this.service});

  final Employee? employee;
  final Regulation? service;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  tg.BackButton get backButton => tg.TelegramWebApp.instance.backButton;

  Employee? selectedEmployee;
  List<Regulation>? selectedRegs;

  String? title;

  @override
  void initState() {
    backButton.onClick(onBackPressed);
    backButton.show();

    selectedEmployee = widget.employee;
    if (widget.service != null) selectedRegs = [widget.service!];

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

  void reload() {
    context.read<LocalRegulationsBloc>().add(FetchRegulationsData());
    context.read<LocalEmployeesBloc>().add(FetchAllEmployeesData());
  }

  void selectEmployee(Employee e) {
    setState(() {
      selectedEmployee = e;
    });
  }

  void selectRegs(List<Regulation> regs) {
    setState(() {
      selectedRegs = regs;
    });
  }

  void changeTitle() {
    if (selectedEmployee != null && selectedRegs == null) {
      setState(() {
        title = 'Выбор услуг';
      });
      return;
    }
    if (selectedRegs != null && selectedEmployee == null) {
      setState(() {
        title = 'Выбор специалиста';
      });
      return;
    }
    title = null;
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    changeTitle();

    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
        builder: (context, regState) {
          return BlocBuilder<LocalAppointmentsBloc, LocalAppointmentsState>(
            builder: (context, appoState) {
              return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
                builder: (context, empState) {
                  return Scaffold(
                    appBar: title != null
                        ? AppBar(
                            title: Text(title!),
                            actions: [
                              IconButton(
                                  onPressed: reload,
                                  icon: const Icon(Icons.autorenew))
                            ],
                          )
                        : null,
                    body: Builder(builder: (context) {
                      if (regState is LocalRegulationsErrorState ||
                          empState is LocalEmployeesError ||
                          appoState is LocalAppointmentsError) {
                        String errorMsg = '';

                        if (regState is LocalRegulationsErrorState) {
                          errorMsg += '${regState.errorMessage}\n';
                        }
                        if (empState is LocalEmployeesError) {
                          errorMsg += '${empState.errorMessage}\n';
                        }
                        if (appoState is LocalAppointmentsError) {
                          errorMsg += '${appoState.errorMessage}\n';
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Произошла ошибка:\n$errorMsg'),
                            ElevatedButton(
                                onPressed: reload,
                                child: const Text('Обновить'))
                          ],
                        );
                      }

                      //TODO из-за LayoutBuilder растягивается контент, нужен фикс
                      if (selectedRegs != null && selectedEmployee == null) {
                        return Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: activeWidth < 800
                                ? constraints.maxWidth
                                : constraints.maxWidth / 2,
                            child: EmployeeSelectionContent(
                              employees: (empState is LocalEmployeesLoaded)
                                  ? empState.employees
                                  : [],
                              onSelected: selectEmployee,
                            ),
                          ),
                        );
                      }

                      //TODO: Сделать бы нормальный CircularProgressIndicator, если не Loaded
                      if (selectedEmployee != null && selectedRegs == null) {
                        return RegSelectionContent(
                          regs: (regState is LocalRegulationsLoadedState)
                              ? regState.regulations
                              : [],
                          onSelected: selectRegs,
                        );
                      }

                      if (selectedRegs != null && selectedEmployee != null) {
                        return TimeSelectionContent(
                          regs: selectedRegs!,
                          appos: (appoState is LocalAppointmentsLoaded)
                              ? appoState.appointments
                              : [],
                          emp: selectedEmployee!,
                        );
                      }

                      return Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: activeWidth < 800
                              ? constraints.maxWidth
                              : constraints.maxWidth / 2,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Новая запись',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Wrap(
                                children: [
                                  AppoTypeWidget(
                                      text: 'Выбрать услуги',
                                      onTap: () {
                                        // context.pu
                                      }),
                                  AppoTypeWidget(
                                      text: 'Выбрать специалиста',
                                      onTap: () {}),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              );
            },
          );
        },
      );
    });
  }
}
