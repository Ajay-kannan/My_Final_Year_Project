import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'RobotoMono',
  colorScheme: const ColorScheme.light(
    background: Color(0xffd9d9d9),
    primary:  Color(0xff212121),
    secondary:  Colors.white54,

  )
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    background:  Color(0xff181a20),
    primary: Colors.white,
    secondary:  Color(0xff1f222a),
  )

);
