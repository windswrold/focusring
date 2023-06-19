import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focusring/const/constant.dart';
import 'package:focusring/public.dart';

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
    backgroundColor: Color(0xFF161819),
    appBarTheme: AppBarTheme(),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: ColorUtils.fromHex("#FF05E6E7"),
      unselectedItemColor: ColorUtils.fromHex("#FF474747"),
    ),
    textTheme: TextTheme(
      //导航标题
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
      ),
      displayMedium: TextStyle(
        color: ColorUtils.fromHex("#FF00CEFF"),
        fontSize: 17.sp,
        fontFamily: fontFamilyRoboto,
      ),
      displaySmall: TextStyle(
        color: ColorUtils.fromHex("#FF9EA3AE"),
        fontSize: 12.sp,
      ),

      // bodyLarge:
    ),
  );
  static final dark = _dark;
}
