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
    tabBarTheme: TabBarTheme(
      unselectedLabelStyle: TextStyle(
          color: ColorUtils.fromHex("#FF9EA3AE"),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400),
      labelStyle: TextStyle(
          color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w400),
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
          fontWeight: FontWeight.w400),
      titleSmall: TextStyle(
          color: ColorUtils.fromHex("#FF02FFE2"),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400),

      displayMedium: TextStyle(
          color: ColorUtils.fromHex("#FF00CEFF"),
          fontSize: 17.sp,
          fontFamily: fontFamilyRoboto,
          fontWeight: FontWeight.w400),
      displaySmall: TextStyle(
          color: ColorUtils.fromHex("#FF9EA3AE"),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400),

      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),

      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
          color: ColorUtils.fromHex("#FF9EA3AE"),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),

      labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontFamily: fontFamilyRoboto,
          fontWeight: FontWeight.w400),
      labelSmall: TextStyle(
        color: Colors.white,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      labelMedium: TextStyle(
          color: ColorUtils.fromHex("#FF9EA3AE"),
          fontSize: 14.sp,
          fontFamily: fontFamilyRoboto,
          fontWeight: FontWeight.w400),

      headlineLarge: TextStyle(
          color: ColorUtils.fromHex("#FF4D5461"),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400),

      headlineMedium: TextStyle(
        color: Colors.white,
        fontSize: 56.sp,
        fontWeight: FontWeight.w400,
      ),

      headlineSmall: TextStyle(
        color: Colors.white,
        fontSize: 30.sp,
        fontWeight: FontWeight.w400,
      ),

      // bodyLarge:
    ),
  );
  static final dark = _dark;

  static final List<Color> weekColors = [
    ColorUtils.fromHex("#FFFFD110"),
    ColorUtils.fromHex("#FF34E050"),
    ColorUtils.fromHex("#FF35D7B2"),
    ColorUtils.fromHex("#FF3586D7"),
    ColorUtils.fromHex("#FF9A45FC"),
    ColorUtils.fromHex("#FFFF397E"),
    ColorUtils.fromHex("#FFFF6D38"),
  ];
}
