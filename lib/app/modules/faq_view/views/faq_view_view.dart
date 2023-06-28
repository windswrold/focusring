import 'package:flutter/material.dart';
import 'package:focusring/views/base/base_pageview.dart';
import 'package:focusring/views/base/custom_image.dart';

import '../../../../public.dart';
import '../controllers/faq_view_controller.dart';

class FaqViewView extends GetView<FaqViewController> {
  const FaqViewView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        controller.onTapList(index);
      },
      child: Container(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w, top: 16.w),
        margin: EdgeInsets.only(
          left: 12.w,
          right: 12.w,
          bottom: 16.w,
        ),
        decoration: BoxDecoration(
          color: ColorUtils.fromHex("#FF000000"),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Get.textTheme.displayLarge,
            ),
            LoadAssetsImage(
              "icons/arrow_right_small",
              width: 7,
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: 'FAQ'.tr,
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return _getListItem(index: index, title: "哈");
        },
      ),
    );
  }
}
