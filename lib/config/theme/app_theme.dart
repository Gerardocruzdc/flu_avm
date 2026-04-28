import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppTheme {
  final Color electusColor;

  AppTheme({
    this.electusColor = const Color(0xFF1E1C36)});
    getTheme() => ThemeData(
      colorSchemeSeed: electusColor,
      appBarTheme: AppBarTheme(
        centerTitle: false,
      )
    );
}