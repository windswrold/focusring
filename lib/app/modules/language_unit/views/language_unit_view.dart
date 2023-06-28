import 'package:flutter/material.dart';
import 'package:focusring/generated/locales.g.dart';
import 'package:focusring/utils/console_logger.dart';
import 'package:focusring/utils/localeManager.dart';
import 'package:focusring/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../../../../public.dart';
import '../controllers/language_unit_controller.dart';

class LanguageUnitView extends GetView<LanguageUnitController> {
  const LanguageUnitView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required Locale title,
  }) {
    return InkWell(
      onTap: () {
        controller.onTapList(index);
      },
      child: Container(
        height: 44,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getLocaleKey(title).tr,
              style: Get.textTheme.displayLarge,
            ),
            Obx(
              () => Visibility(
                visible: getLocaleKey(controller.selectLocale!.value!) ==
                    getLocaleKey(title),
                child: LoadAssetsImage(
                  "icons/language_selected",
                  width: 44,
                  height: 44,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "language".tr,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: ColorUtils.fromHex("#FF000000"),
          ),
          child: ListView.builder(
            itemCount: controller.localDatas.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var a = controller.localDatas[index];
              return _getListItem(index: index, title: a);
            },
          )),
    );
  }
}
