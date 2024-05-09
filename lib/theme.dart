import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Menyesuaikan warna latar belakang dan teks
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(color: Colors.black),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
          fontSize: 24,
          color: Colors.white,
          fontFamily: GoogleFonts.rubik().fontFamily),
      headlineSmall: TextStyle(
          color: Colors.white, fontFamily: GoogleFonts.rubik().fontFamily),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
      // Sesuaikan teks lainnya sesuai kebutuhan
    ),
    // Menyesuaikan warna primer dan aksen
    primaryColor: Colors.blue,
    hintColor: Colors.blueAccent,
    focusColor: Colors.white,
    unselectedWidgetColor: Color.fromRGBO(60, 60, 60, 100),
    splashColor: Color.fromRGBO(7, 4, 23, 100)
    // Dan pengaturan tema lainnya sesuai kebutuhan
    );
final ThemeData lightTheme = ThemeData.light().copyWith(
  // Menyesuaikan warna latar belakang dan teks
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(color: Colors.white),
  textTheme: TextTheme(
    headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: GoogleFonts.rubik().fontFamily),
    headlineSmall: TextStyle(
        color: Colors.black, fontFamily: GoogleFonts.rubik().fontFamily),
    bodySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    // Sesuaikan teks lainnya sesuai kebutuhan
  ),
  // Menyesuaikan warna primer dan aksen
  primaryColor: Colors.blue,
  hintColor: Colors.blueAccent,
  focusColor: Colors.black,
  splashColor: Colors.white,
  unselectedWidgetColor: Color.fromRGBO(60, 60, 60, 100),
  // Dan pengaturan tema lainnya sesuai kebutuhan
);
