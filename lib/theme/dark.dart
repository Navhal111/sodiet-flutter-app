import 'package:flutter/material.dart';

ThemeData dark = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: const Color(0xff8BC34A),
  primaryColorDark: const Color(0xff2E7D32),
  secondaryHeaderColor: const Color(0xff8BC34A),
  disabledColor: const Color(0xffF2F2F2),
  brightness: Brightness.light,
  hintColor: Color.fromARGB(255, 195, 193, 193),
  // dialogBackgroundColor:Color(0xff52C41A) ,

  unselectedWidgetColor: const Color(0xff87888E),

  dividerColor: const Color(0xff222322),
  cardColor: Color.fromARGB(255, 81, 80, 80),
  canvasColor: Color.fromARGB(255, 255, 255, 255),

  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xff5056F6))),
  colorScheme: const ColorScheme.light(
          primary: Color(0xff5056F6), secondary: const Color(0xff5056F6))
      .copyWith(background: const Color(0xFFFfffff))
      .copyWith(error: const Color(0xFFE84D4F)),
);
