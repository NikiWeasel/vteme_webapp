import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_employees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_portfolio_photos/local_portfolio_photos_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_regulations/local_regulations_bloc.dart';
import 'package:vteme_tg_miniapp/core/models/employee.dart';
import 'package:vteme_tg_miniapp/core/models/regulation.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/employees_review_widget.dart';
import 'package:vteme_tg_miniapp/features/home/view/widgets/regulation_tile.dart';
import 'package:vteme_tg_miniapp/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final TelegramWebApp telegram = TelegramWebApp.instance;
  // TelegramUser? telegramUser;

  // @override
  // void initState() {
  //   super.initState();
  //   // telegramUser = telegram.initData.user;
  //
  //   // FlutterError.onError = (details) {
  //   //   showSnackBar("Flutter error: $details");
  //   //   print("Flutter error happened: $details");
  //   // };
  //
  //   // TelegramWebApp.instance.ready();
  //
  //   // check();
  // }

  // void check() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   // isDefinedVersion = telegram.isVersionAtLeast('Bot API 6.1');
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // if (telegramUser == null){
    //   return Text('Error');
    // }
    // TelegramWebApp.instance.initData.;
    double activeWidth = MediaQuery.of(context).size.width <= 800
        ? MediaQuery.of(context).size.width
        : 800;

    launchURL() async {
      final Uri url = Uri.parse(kMapUrl);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return BlocBuilder<LocalPortfolioPhotosBloc, LocalPortfolioPhotosState>(
      builder: (context, portfolioUrlsState) {
        return BlocBuilder<LocalEmployeesBloc, LocalEmployeesState>(
          builder: (context, empState) {
            return BlocBuilder<LocalRegulationsBloc, FetchRegulationsState>(
              builder: (context, regsState) {
                List<Employee> emps = [];
                List<Regulation> regs = [];
                Map<String, List<String>> urls = {};

                if (portfolioUrlsState is LocalPortfolioPhotosLoadedState) {
                  urls = portfolioUrlsState.downloadUrls;
                }
                if (regsState is LocalRegulationsLoadedState) {
                  regs = regsState.regulations;
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: activeWidth,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/logo.png',
                                      height: 70,
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          'г Хабаровск, ул Нерчинская, 6',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        TextButton(
                                            onPressed: launchURL,
                                            child: Text(
                                              'Показать на карте',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Специалисты ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: '${emps.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .color
                                                ?.withOpacity(0.5),
                                          ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: activeWidth,
                              child: EmployeesReviewWidget(
                                  emps: emps, portfolioUrls: urls),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Услуги ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: '${regs.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .color
                                                  ?.withOpacity(0.5),
                                            ),
                                      )
                                    ],
                                  ),
                                )),
                            for (var r in regs)
                              SizedBox(
                                  width: activeWidth,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: RegulationTile(
                                      regulation: r,
                                      onPressed: () {
                                        context.go('/schedule_appo',
                                            extra: {'service': r});
                                      },
                                      isSecondaryScreen: false,
                                    ),
                                  )),
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
