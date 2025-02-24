import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
import 'package:vteme_tg_miniapp/core/bloc/fetch_emloyees/local_employees_bloc.dart';
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
                            Image.asset(
                              'assets/images/logo.png',
                              height: 70,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Наши специалисты',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            EmployeesReviewWidget(
                                emps: emps, portfolioUrls: urls),
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
                              ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width / 2,
                                  ),
                                  child: RegulationTile(regulation: r)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Где нас найти',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  // context.push('/map');
                                  launchURL();
                                },
                                child: Text('где')),
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
