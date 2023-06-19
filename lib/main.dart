import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/utils/localeManager.dart';

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
        title: "",
        theme: KTheme.light,
        darkTheme: KTheme.dark,
        themeMode: ThemeMode.dark,
        initialRoute: AppPages.INITIAL,
        locale: Get.deviceLocale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        translationsKeys: AppTranslation.translations,
        supportedLocales:
            AppTranslation.translations.keys.map((e) => toLocale(e)).toList(),
        fallbackLocale: fallbackLocale,
        getPages: AppPages.routes,
      );
    },
  ));
}
