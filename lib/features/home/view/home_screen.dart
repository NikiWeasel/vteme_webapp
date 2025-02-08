import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employees_review_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final TelegramWebApp telegram = TelegramWebApp.instance;
  // TelegramUser? telegramUser;

  @override
  void initState() {
    super.initState();
    // telegramUser = telegram.initData.user;

    // FlutterError.onError = (details) {
    //   showSnackBar("Flutter error: $details");
    //   print("Flutter error happened: $details");
    // };

    // TelegramWebApp.instance.ready();

    check();
  }

  void check() async {
    await Future.delayed(const Duration(seconds: 2));
    // isDefinedVersion = telegram.isVersionAtLeast('Bot API 6.1');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (telegramUser == null){
    //   return Text('Error');
    // }
    // TelegramWebApp.instance.initData.;

    return BlocBuilder<LocalPortfolioPhotosBloc, LocalPortfolioPhotosState>(
      builder: (context, portfolioUrlsState) {
        return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
          builder: (context, empState) {
            return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
              builder: (context, regsState) {
                List<Employee> emps = [];
                Map<String, List<String>> urls = {};

                if (portfolioUrlsState is LocalPortfolioPhotosLoadedState) {
                  urls = portfolioUrlsState.downloadUrls;
                }
                if (empState is LocalEmployeesError) {
                  return Text(empState.errorMessage);
                }
                if (empState is LocalEmployeesLoaded) {
                  emps = empState.employees;
                }
                if (emps.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Наши специалисты:',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            EmployeesReviewWidget(
                                emps: emps, portfolioUrls: urls),
                          ]),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
