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
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
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
        fontWeight: FontWeight.w400,
      ),

      titleMedium: TextStyle(
        color: ColorUtils.fromHex("#FF09C2EE"),
        fontSize: 14.sp,
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

      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
      ),

      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
      ),
      bodyMedium: TextStyle(
        color: ColorUtils.fromHex("#FF9EA3AE"),
        fontSize: 14.sp,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
      ),

      labelLarge: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontFamily: fontFamilyRoboto,
      ),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
      ),
      labelMedium: TextStyle(
        color: ColorUtils.fromHex("#FF9EA3AE"),
        fontSize: 14.sp,
        fontFamily: fontFamilyRoboto,
      ),

      titleSmall: TextStyle(
        color: ColorUtils.fromHex("#FF02FFE2"),
        fontSize: 12.sp,
      ),

      // bodyLarge:
    ),
  );
  static final dark = _dark;
}
