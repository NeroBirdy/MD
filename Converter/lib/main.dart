import 'package:flutter/material.dart';

import 'package:converter/pages/home.dart';
import 'package:converter/pages/weight.dart';
import 'package:converter/pages/length.dart';
import 'package:converter/pages/exchange.dart';
import 'package:converter/pages/temperature.dart';
import 'package:converter/pages/square.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      initialRoute: '/home',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const Home(),
        '/weight': (context) => const Weight(),
        '/length': (context) => const Length(),
        '/exchange': (context) => const Exchange(),
        '/temp': (context) => const Temperature(),
        '/square': (context) => const Square(),
      },
    );
  }
}
