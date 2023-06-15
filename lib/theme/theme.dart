import 'package:flutter/material.dart';

class KTheme {
  static final _light = ThemeData(
    brightness: Brightness.light,
    backgroundColor: Color(0xFF161819),
    textTheme: TextTheme(
      //标题
      titleLarge: TextStyle(
        color: Colors.red,
        fontSize: 24.sp,
      ),

      // bodyLarge:
    ),
  );
  static final light = _light;

  static final _dark = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Colors.red,
    textTheme: TextTheme(
      //导航标题
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
      ),

      // bodyLarge:
    ),
  );
  static final dark = _dark;
}
