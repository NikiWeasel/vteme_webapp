import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_web_app/telegram_web_app.dart' as tg;
import 'package:vteme_tg_miniapp/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/appo_type_widget.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/contact_info_widget.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_selection_content.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/reg_selection_content.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection_content.dart';

enum AppointmentStep {
  selectStart,
  selectEmployee,
  selectRegulations,
  selectTime,
  contactInfo
}

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
  SelectedRegulationOption? selectedRegsWithOption;

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

  void selectRegsWithTime(SelectedRegulationOption selectedRegulationOption) {
    setState(() {
      selectedRegsWithOption = selectedRegulationOption;
    });
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
        builder: (context, regState) {
          return BlocBuilder<LocalAppointmentsBloc, LocalAppointmentsState>(
            builder: (context, appoState) {
              return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
                builder: (context, empState) {
                  return Scaffold(
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
                      //TODO Кнопки назад не работают
                      if (regState is LocalRegulationsLoadedState &&
                          empState is LocalEmployeesLoaded &&
                          appoState is LocalAppointmentsLoaded) {
                        if (selectedRegs != null && selectedEmployee == null) {
                          return Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: activeWidth,
                              child: EmployeeSelectionContent(
                                employees: empState.employees,
                                onSelected: selectEmployee,
                              ),
                            ),
                          );
                        }

                        if (selectedEmployee != null && selectedRegs == null) {
                          return RegSelectionContent(
                            regs: regState.regulations,
                            onSelected: selectRegs,
                          );
                        }

                        if (selectedRegs != null &&
                            selectedEmployee != null &&
                            selectedRegsWithOption == null) {
                          return TimeSelectionContent(
                            regs: selectedRegs!,
                            appos: appoState.appointments,
                            emp: selectedEmployee!,
                            selectRegsWithTime: selectRegsWithTime,
                          );
                        }

                        if (selectedRegs != null &&
                            selectedEmployee != null &&
                            selectedRegsWithOption != null) {
                          return ContactInfoWidget(
                            selectedEmployee: selectedEmployee!,
                            selectedRegs: selectedRegs!,
                            selectedRegsWithOption: selectedRegsWithOption!,
                          );
                        }

                        return Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: activeWidth,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'Новая запись',
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
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
                      }
                      return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
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
