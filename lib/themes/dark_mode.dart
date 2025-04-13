import 'package:flutter/material.dart';
ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 20, 20, 20),
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 20, 20, 20),
    primary: const Color.fromARGB(255, 122, 122, 122),
    secondary: const Color.fromARGB(255, 30, 30, 30),
    inversePrimary: Colors.grey.shade300,
  ),
);