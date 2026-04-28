import 'package:flu_avm/config/config.dart';
import 'package:flu_avm/presentation/screens/domus/domus_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flu_avm',

      theme:AppTheme(electusColor: Colors.pinkAccent).getTheme(),
      home: DomusScreen()
    );
  }
}

