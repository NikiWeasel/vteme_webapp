import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:vteme_tg_miniapp/core/models/selected_regulation_option.dart';
import 'package:vteme_tg_miniapp/features/home/view/home_screen.dart';

// import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:vteme_tg_miniapp/core/repository/local_appointments_repository.dart';
import 'package:vteme_tg_miniapp/core/repository/local_regulations_repository.dart';
import 'package:vteme_tg_miniapp/core/repository/local_employees_repository.dart';
import 'package:vteme_tg_miniapp/core/repository/local_portfolio_photos_repository.dart';
import 'package:vteme_tg_miniapp/core/repository/actions_appointment_repository.dart';

import 'package:vteme_tg_miniapp/core/app_router.dart';
import 'package:vteme_tg_miniapp/core/bloc/actions_appointments/actions_appointment_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_appointments/local_appointments_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/core/theme.dart';
import 'package:vteme_tg_miniapp/firebase_options.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

ValueNotifier<SelectedRegulationOption?> selectedRegulationWithTimeOptions =
    ValueNotifier<SelectedRegulationOption?>(null);

bool tgSupported = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (TelegramWebApp.instance.isSupported) {
      TelegramWebApp.instance.ready();
      tgSupported = true;
      Future.delayed(
          const Duration(seconds: 1), TelegramWebApp.instance.expand);
    }
  } catch (e) {
    print("Error happened in Flutter while loading Telegram $e");
    // add delay for 'Telegram seldom not loading' bug
    await Future.delayed(const Duration(milliseconds: 200));
    main();
    return;
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('ru', null);

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // final LocalPortfolioPhotosRepository fetchDataRepository =
  //     LocalPortfolioPhotosRepository(
  //         firebaseAuth: firebaseAuth, firebaseStorage: firebaseStorage);

  final LocalEmployeesRepository localEmployeesRepository =
      LocalEmployeesRepository(
    firebaseFirestore: firebaseFirestore,
  );

  final LocalPortfolioPhotosRepository fetchDataRepository =
      LocalPortfolioPhotosRepository(firebaseStorage: firebaseStorage);

  final LocalAppointmentsRepository localAppointmentsRepository =
      LocalAppointmentsRepository(
          firebaseFirestore: firebaseFirestore,
          firebaseStorage: firebaseStorage);

  final LocalRegulationsRepository localRegulationsRepository =
      LocalRegulationsRepository(
    firebaseFirestore: firebaseFirestore,
  );

  final actionsAppointmentRepository = ActionsAppointmentRepository(
    firebaseFirestore: firebaseFirestore,
  );

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<LocalEmployeesBloc>(
        create: (context) => LocalEmployeesBloc(localEmployeesRepository)
          ..add(FetchAllEmployeesData()),
      ),
      BlocProvider<LocalAppointmentsBloc>(
        create: (context) => LocalAppointmentsBloc(localAppointmentsRepository)
          ..add(FetchAppointmentsData()),
      ),
      BlocProvider<LocalRegulationsBloc>(
        create: (context) => LocalRegulationsBloc(localRegulationsRepository)
          ..add(FetchRegulationsData()),
      ),
      BlocProvider<LocalPortfolioPhotosBloc>(
        create: (context) => LocalPortfolioPhotosBloc(fetchDataRepository)
          ..add(FetchPortfolioPhotosData()),
      ),
      BlocProvider<ActionsAppointmentBloc>(
        create: (context) =>
            ActionsAppointmentBloc(actionsAppointmentRepository),
      ),
    ],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scrollBehavior: MyCustomScrollBehavior(),

      // localizationsDelegates: const [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
      // supportedLocales: const [
      //   Locale('en', 'US'), // English
      //   Locale('ru', 'RU'), // Russian
      // ],
      theme: tgSupported
          ? TelegramThemeUtil.getTheme(TelegramWebApp.instance)
          : getTheme(0xFF607D8B),
      routerConfig: router,
      // home: const App(),
    ),
  ));
}
