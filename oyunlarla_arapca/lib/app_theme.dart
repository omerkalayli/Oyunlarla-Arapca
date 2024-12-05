import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme = ThemeData().copyWith(
    textTheme: GoogleFonts.montserratTextTheme(),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 64));
