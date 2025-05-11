import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:vteme_tg_miniapp/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/appointment.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
import 'package:vteme_tg_miniapp/core/utils/functions.dart';
import 'package:vteme_tg_miniapp/main.dart';

class ContactInfoWidget extends StatefulWidget {
  const ContactInfoWidget(
      {super.key,
      required this.selectedEmployee,
      required this.selectedRegs,
      required this.selectedRegsWithOption,
      required this.onBackPressed});

  final Employee selectedEmployee;
  final List<Regulation> selectedRegs;
  final SelectedRegulationOption selectedRegsWithOption;

  final void Function() onBackPressed;

  @override
  State<ContactInfoWidget> createState() => _ContactInfoWidgetState();
}

class _ContactInfoWidgetState extends State<ContactInfoWidget> {
  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  final _formKey = GlobalKey<FormState>();

  List<Appointment> apposToSend = [];

  bool isLoading = false;

  String enteredName = '';
  String enteredSurname = '';
  String enteredNumber = '';

  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController numberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    numberController = TextEditingController();

    if (tgSupported) {
      var userInitData = TelegramWebApp.instance.initData.user;
      nameController.text = userInitData.firstname ?? '';
      surnameController.text = userInitData.lastname ?? '';
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void setLoadingBool(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  ({int duration, String serviceName}) getDurationAndName(
      List<Regulation> regs) {
    int duration = 0;
    String serviceName = '';

    for (var e in regs) {
      duration += e.duration;
      serviceName += '${e.name} + ';
    }
    serviceName = serviceName.substring(0, serviceName.length - 3);
    return (duration: duration, serviceName: serviceName);
  }

  void clearAndShowSnackBar(String text, {Duration? duration}) {
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      showSnackBar(context: context, text: text, duration: duration);
    }
  }

  void addAllAppos(
      List<Appointment> appos, void Function(Appointment) addSingleAppo) {
    final bloc = context.read<ActionsAppointmentBloc>();

    int currentIndex = 0;
    bool isProcessing = false;

    late final StreamSubscription subscription;
    subscription = bloc.stream.listen((state) {
      if (!isProcessing) return;

      if (state is ActionsAppointmentLoadedState) {
        // print('Успешно добавлен ${appos[currentIndex].serviceName}');
        currentIndex++;

        if (currentIndex < appos.length) {
          addSingleAppo(appos[currentIndex]);
        } else {
          clearAndShowSnackBar('Запись прошла успешно');
          setLoadingBool(false);
          // print('Все добавлены!');
          subscription.cancel(); // Отписываемся
          if (mounted) {
            context.go('/home');
          }
        }
      }
      if (state is ActionsAppointmentErrorState) {
        // print('Ошибка при добавлении ${appos[currentIndex].serviceName}');
        clearAndShowSnackBar(
            'Ошибка при добавлении ${appos[currentIndex].serviceName}');
        currentIndex++;
        if (currentIndex < appos.length) {
          addSingleAppo(appos[currentIndex]);
        } else {
          subscription.cancel();
        }
      }
      if (state is ActionsAppointmentLoadingState) {
        if (!isLoading) {
          setLoadingBool(true);
          clearAndShowSnackBar('Отправка записи. Не закрывайте приложение',
              duration: const Duration(seconds: 60));
        }
      }
    });

    // первый
    if (appos.isNotEmpty) {
      isProcessing = true;
      addSingleAppo(appos[currentIndex]);
    }
  }

  void createAppos() {
    var selectedRegsWithOption = widget.selectedRegsWithOption;

    if (selectedRegsWithOption is SelectedCombined) {
      var regsWithTime = selectedRegsWithOption.combined;

      var r = getDurationAndName(regsWithTime.regulations);

      apposToSend = [
        Appointment(
          clientName: '$enteredName $enteredSurname',
          clientNumber: enteredNumber,
          date: getDate(regsWithTime.timeSlotsByDate),
          duration: r.duration,
          masterId: widget.selectedEmployee.employeeId,
          serviceName: r.serviceName,
        )
      ];
    }
    if (selectedRegsWithOption is SelectedSeparated) {
      var regsWithTime = selectedRegsWithOption.separated;

      apposToSend = [];
      for (var r in regsWithTime) {
        apposToSend.add(Appointment(
          clientName: '$enteredName $enteredSurname',
          clientNumber: enteredNumber,
          date: getDate(r.timeSlotsByDate),
          duration: r.regulation.duration,
          masterId: widget.selectedEmployee.employeeId,
          serviceName: r.regulation.name,
        ));
      }
    }
  }

  bool validateAndSave() {
    bool isOk = _formKey.currentState!.validate();

    if (!isOk) return false;
    _formKey.currentState!.save();
    return true;
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
          title: const Text('Контактная информация'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: activeWidth,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Имя',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пустое поле';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredName = value!;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: surnameController,
                        decoration: InputDecoration(
                          labelText: 'Фамилия',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пустое поле';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredSurname = value!;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        controller: numberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [phoneMaskFormatter],
                        decoration: InputDecoration(
                          labelText: 'Телефон',
                          hintText: '+7 (___) ___-__-__',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          // Проверка, что строка полностью введена (все цифры на месте)
                          if (value == null || value.isEmpty) {
                            return 'Пустое поле';
                          } else if (!phoneMaskFormatter.isFill()) {
                            return 'Введите полный номер';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          enteredNumber = value!;
                        },
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                            onPressed: !isLoading
                                ? () {
                                    if (validateAndSave()) {
                                      createAppos();
                                      addAllAppos(apposToSend, (appo) {
                                        context
                                            .read<ActionsAppointmentBloc>()
                                            .add(CreateAppointmentEvent(
                                                appointment: appo));
                                      });
                                    }
                                  }
                                : null,
                            icon: isLoading
                                ? Transform.scale(
                                    scale: 0.5,
                                    child: const CircularProgressIndicator())
                                : const Icon(Icons.send),
                            label: const Text('Записаться')),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
