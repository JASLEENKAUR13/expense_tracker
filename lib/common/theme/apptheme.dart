import 'package:expense_tracker/common/theme/AppPallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTheme {

  static InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: GoogleFonts.poppins(
      fontSize: 16,
      color: AppPallete.primaryBlue,   // ✅ was iconBackground
    ),
    filled: true,
    fillColor: AppPallete.surface,        // ✅ was cardWhite.withOpacity
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppPallete.iconBackground, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppPallete.primaryBlue, width: 2),
    ),
  );


}