import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: const Color.fromRGBO(228, 183, 229, 1),
);

ThemeData darkMode = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: const Color.fromARGB(255, 47, 23, 48));
