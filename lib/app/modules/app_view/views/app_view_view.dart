import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/utils/localeManager.dart';

import 'package:get/get.dart';

import '../../../../public.dart';
import '../controllers/app_view_controller.dart';

class AppViewView extends GetView<AppViewController> {
  const AppViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
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
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
          locale: toLocale(SPManager.getAppLanguage()),
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
    );
  }
}
