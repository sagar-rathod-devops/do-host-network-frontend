import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'themes.dart';

ThemeData darkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
    toolbarTextStyle: ThemeData.light().textTheme.displayMedium?.copyWith(
      fontFamily: ThemeConfig.pangramRegular,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.white),
  textTheme: ThemeData.dark().textTheme.copyWith(
    titleMedium: GoogleFonts.roboto(color: Colors.white),
    titleSmall: GoogleFonts.roboto(color: Colors.white.withOpacity(0.5)),
    displayLarge: GoogleFonts.roboto(color: Colors.white),
    displayMedium: GoogleFonts.roboto(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.roboto(color: ThemeConfig.textColor6B698E),
    displaySmall: GoogleFonts.roboto(
      color: Colors.white,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: GoogleFonts.roboto(color: ThemeConfig.textColorBCBFC2),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateColor.resolveWith(
      (states) => Colors.white.withOpacity(0.3),
    ),
  ),
  colorScheme: const ColorScheme.dark().copyWith(
    secondary: Color(0xff73777a),
    primary: Colors.white,
    onPrimary: Color(0xffA0A0A0),
    outline: Colors.black,
    onSurface: Color(0xff202934),
    brightness: Brightness.dark,
    surface: Color(0xff202934),
    primaryContainer: Color(0xff2d3236),
    onPrimaryContainer: Color(0xff5a5f62),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    linearTrackColor: Colors.white,
    color: ThemeConfig.primaryColor,
  ),
  primaryColor: ThemeConfig.primaryColor,
  scaffoldBackgroundColor: ThemeConfig.darkBackColor,
);
