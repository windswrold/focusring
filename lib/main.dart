import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/pages/import/controllers/current_wallet_state.dart';
import 'package:focusring/pages/import/views/import_a.dart';
import 'package:focusring/public.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  KCurrentWalletController controller = Get.put(KCurrentWalletController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: kDesignSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: '',
            translationsKeys: AppTranslation.translations,
            locale: Get.deviceLocale,

            // locale: toLocale(config.extra.locale),
            // fallbackLocale: fallbackLocale,
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // supportedLocales: AppTranslation.translations.keys
            //     .map((e) => toLocale(e))
            //     .toList(),
            builder: BotToastInit(), //1. call BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()],
            home: PImportWallet(),
          );
        });
  }
}
