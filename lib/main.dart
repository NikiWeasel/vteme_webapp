import 'package:flutter/material.dart';
import 'package:vteme_tg_miniapp/screens/home_screen.dart';
import 'package:telegram_web_app/telegram_web_app.dart';
import 'package:google_fonts/google_fonts.dart';


final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.light,
    seedColor: const Color.fromARGB(255, 154, 0, 165),
  ),
  textTheme: GoogleFonts.rubikTextTheme(),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ButtonStyle(
  //       backgroundColor: WidgetStateProperty.all<Color>(
  //           Color.fromARGB(255, 236, 200, 200)),
  //       foregroundColor: WidgetStateProperty.all<Color>(Colors.white)),
  // )
);

void main() async {

  // try {
  //   if (TelegramWebApp.instance.isSupported) {
  //     TelegramWebApp.instance.ready();
  //     Future.delayed(const Duration(seconds: 1), TelegramWebApp.instance.expand);
  //   }
  // } catch (e) {
  //   print("Error happened in Flutter while loading Telegram $e");
  //   // add delay for 'Telegram not loading sometimes' bug
  //   await Future.delayed(const Duration(milliseconds: 200));
  //   main();
  //   return;
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Web App Example',
      // theme: TelegramThemeUtil.getTheme(TelegramWebApp.instance),
      theme: theme,
      home: const HomeScreen(),
    );
  }
}