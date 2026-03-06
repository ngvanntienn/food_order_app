import 'package:flutter/material.dart';
import 'package:food_order/constants/style.dart';

ThemeData lightMode = ThemeData(
    fontFamily: 'InterTight',
    colorScheme: ColorScheme.light(
      surface: Colors.white,
      primary: Colors.grey.shade500,
      secondary: mainYellow,
      tertiary: const Color.fromARGB(255, 237, 237, 237),
      inversePrimary: Colors.grey.shade700,
    ));
