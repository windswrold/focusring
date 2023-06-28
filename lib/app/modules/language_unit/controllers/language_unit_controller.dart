import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/localeManager.dart';
import 'package:get/get.dart';

import '../../../../public.dart';

class LanguageUnitController extends GetxController {
  //TODO: Implement LanguageUnitController

  RxList<Locale> localDatas = <Locale>[].obs;

  Rx<Locale?>? selectLocale;

  @override
  void onInit() {
    super.onInit();

    selectLocale = toLocale(SPManager.getAppLanguage()).obs;
    localDatas =
        AppTranslation.translations.keys.map((e) => toLocale(e)).toList().obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapList(int index) {
    var l = localDatas[index];
    selectLocale?.value = localDatas[index];
    Get.updateLocale(l);
    SPManager.setAppLanguage(l);
  }
}
