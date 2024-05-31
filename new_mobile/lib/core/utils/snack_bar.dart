 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SnackBar snackBar(errorMessage) {
  return SnackBar(
            content: Text(
              errorMessage,
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          );
 }