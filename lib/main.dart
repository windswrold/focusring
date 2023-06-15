import 'package:flutter/material.dart';
import 'package:focusring/theme/theme.dart';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app/routes/app_pages.dart';
import 'const/constant.dart';

void main() {
  runApp(ScreenUtilInit(
    designSize: kDesignSize,
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, child) {
      return GetMaterialApp(
        title: "Application",
        theme: KTheme.light,
        darkTheme: KTheme.dark,
        themeMode: ThemeMode.dark,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      );
    },
  ));
}
