import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData getTheme(int seedColor) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Color(seedColor),
    ),
    textTheme: GoogleFonts.montserratTextTheme(),
  );
}

final smallButton = ButtonStyle(
  minimumSize: WidgetStateProperty.all(const Size(35, 35)),
  padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 0, vertical: 0.0)),
);
