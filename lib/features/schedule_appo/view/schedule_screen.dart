import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_categories/local_categories_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/appo_type_widget.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/contact_info_widget.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/employee_selection_content.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/reg_selection_content.dart';
import 'package:vteme_tg_miniapp/features/schedule_appo/view/widgets/time_selection_content.dart';

enum AppointmentStep {
  selectEmployee,
  selectRegulations,
  selectTime,
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key, this.employee, this.service});

  final Employee? employee;
  final Regulation? service;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  Employee? selectedEmployee;
  List<Regulation>? selectedRegs;
  SelectedRegulationOption? selectedRegsWithOption;

  List<AppointmentStep> appoSteps = [];

  bool didCheckDifferentAppos = false;

  @override
  void initState() {
    super.initState();
    selectedEmployee = widget.employee;
    if (widget.service != null) selectedRegs = [widget.service!];

    appoSteps.clear();
  }

  void onBackPressed() {
    if (appoSteps.isEmpty) {
      context.go('/home');
      return;
    }
    setState(() {
      switch (appoSteps.last) {
        case AppointmentStep.selectRegulations:
          selectedRegs = null;
        case AppointmentStep.selectEmployee:
          selectedEmployee = null;
        case AppointmentStep.selectTime:
          selectedRegsWithOption = null;
      }
    });
    appoSteps.removeLast();
  }

  void reload() {
    context.read<LocalRegulationsBloc>().add(FetchRegulationsData());
    context.read<LocalEmployeesBloc>().add(FetchAllEmployeesData());
  }

  void selectEmployee(Employee e) {
    setState(() {
      selectedEmployee = e;
    });
    appoSteps.add(AppointmentStep.selectEmployee);
  }

  void selectRegs(List<Regulation> regs) {
    setState(() {
      selectedRegs = regs;
    });
    appoSteps.add(AppointmentStep.selectRegulations);
  }

  void selectRegsWithTime(SelectedRegulationOption selectedRegulationOption) {
    setState(() {
      selectedRegsWithOption = selectedRegulationOption;
    });
    appoSteps.add(AppointmentStep.selectTime);
  }

  void addAppoStep(AppointmentStep appoStep) {
    if (appoSteps.contains(appoStep)) return;

    appoSteps.add(appoStep);
  }

  @override
  Widget build(BuildContext context) {
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    return LayoutBuilder(builder: (context, constraints) {
      return BlocBuilder<LocalCategoriesBloc, FetchCategoriesState>(
        builder: (context, catState) {
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
                            if (catState is LocalCategoriesErrorState) {
                              errorMsg += '${catState.errorMessage}\n';
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
                          if (regState is LocalRegulationsLoadedState &&
                              empState is LocalEmployeesLoaded &&
                              appoState is LocalAppointmentsLoaded &&
                              catState is LocalCategoriesLoadedState) {
                            if (selectedRegs != null &&
                                selectedEmployee == null) {
                              didCheckDifferentAppos = false;
                              return Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: activeWidth,
                                  child: EmployeeSelectionContent(
                                    employees: empState.employees,
                                    onSelected: selectEmployee,
                                    onBackPressed: onBackPressed,
                                    allCategories: catState.categories,
                                    selectedRegulations: selectedRegs!,
                                  ),
                                ),
                              );
                            }

                            if (selectedEmployee != null &&
                                selectedRegs == null) {
                              didCheckDifferentAppos = false;
                              return RegSelectionContent(
                                regs: regState.regulations,
                                onSelected: selectRegs,
                                onBackPressed: onBackPressed,
                                allCategories: catState.categories,
                                selectedEmployee: selectedEmployee!,
                              );
                            }

                            if (selectedRegs != null &&
                                selectedEmployee != null &&
                                selectedRegsWithOption == null) {
                              didCheckDifferentAppos = false;
                              return TimeSelectionContent(
                                regs: selectedRegs!,
                                appos: appoState.appointments,
                                emp: selectedEmployee!,
                                selectRegsWithTime: selectRegsWithTime,
                                onBackPressed: onBackPressed,
                              );
                            }

                            if (selectedRegs != null &&
                                selectedEmployee != null &&
                                selectedRegsWithOption != null) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!didCheckDifferentAppos) {
                                  context
                                      .read<LocalAppointmentsBloc>()
                                      .add(FetchAppointmentsData());
                                  didCheckDifferentAppos = true;
                                }
                              });
                              return ContactInfoWidget(
                                selectedEmployee: selectedEmployee!,
                                selectedRegs: selectedRegs!,
                                selectedRegsWithOption: selectedRegsWithOption!,
                                onBackPressed: onBackPressed,
                                allAppos: appoState.appointments,
                              );
                            }

                            return Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: activeWidth,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text('Новая запись',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface)),
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
        },
      );
    });
  }
}
