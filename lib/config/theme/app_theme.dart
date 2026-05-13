import 'package:flutter/material.dart';

class AppTheme {
  final Color electusColor;
  final bool tenebrisModusEst;

  AppTheme({
    this.electusColor = const Color(0xFF1E1C36),
    this.tenebrisModusEst = false,
  });
    ThemeData getTheme() => ThemeData(
      colorSchemeSeed: electusColor,
      brightness: tenebrisModusEst ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: tenebrisModusEst ? electusColor : electusColor.withAlpha(20),
        centerTitle: false,
      )
    );
}