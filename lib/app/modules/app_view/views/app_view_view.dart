import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focusring/app/routes/app_pages.dart';
import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/theme/theme.dart';
import 'package:focusring/utils/localeManager.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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
        return RefreshConfiguration(
          headerBuilder: () => WaterDropHeader(),
          footerBuilder: () => ClassicFooter(),
          headerTriggerDistance:
              80.0, // header trigger refresh trigger distance
          springDescription: SpringDescription(
              stiffness: 170,
              damping: 16,
              mass:
                  1.9), // custom spring back animate,the props meaning see the flutter api
          maxOverScrollExtent:
              100, //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
          maxUnderScrollExtent: 0, // Maximum dragging range at the bottom
          enableScrollWhenRefreshCompleted:
              true, //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
          enableLoadingWhenFailed:
              true, //In the case of load failure, users can still trigger more loads by gesture pull-up.
          hideFooterWhenNotFull:
              false, // Disable pull-up to load more functionality when Viewport is less than one screen
          enableBallisticLoad: true,
          child: GetMaterialApp(
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
            supportedLocales: AppTranslation.translations.keys
                .map((e) => toLocale(e))
                .toList(),
            fallbackLocale: fallbackLocale,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
