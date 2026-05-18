import 'package:flutter/material.dart';

String exColorAdHex(Color color) {
  final String hex = color.toARGB32().toRadixString(16).padLeft(8, '0');
  return '#${hex.substring(2).toUpperCase()}'; // Omitimos los primeros 2 caracteres (alpha)
}