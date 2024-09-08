import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF38B000), // Container and iconColor
    scaffoldBackgroundColor: (Colors.black54), // Background color
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.roboto(color: Colors.white),
      titleMedium: GoogleFonts.roboto(color: Colors.white, fontSize: 20), // Text color
    ),
    iconTheme: const IconThemeData(color: Colors.black), // Icon color
  );
}
