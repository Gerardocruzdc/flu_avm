import 'package:flutter/material.dart';

class AppTheme {
  final Color electusColor;

  AppTheme({
    this.electusColor = const Color(0xFF1E1C36)});
    ThemeData getTheme() => ThemeData(
      colorSchemeSeed: electusColor,
      appBarTheme: AppBarTheme(
        centerTitle: false,
      )
    );
}