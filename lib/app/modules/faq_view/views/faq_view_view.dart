import 'package:flutter/material.dart';
import 'package:focusring/views/base/base_pageview.dart';
import 'package:focusring/views/base/custom_image.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../public.dart';
import '../controllers/faq_view_controller.dart';

class FaqViewView extends GetView<FaqViewController> {
  const FaqViewView({Key? key}) : super(key: key);

  Widget _getListItem({
    required int index,
    required String title,
  }) {
    return Container(
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
      child: InkWell(
        onTap: () {
          controller.onTapList(index);
        },
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
      body: Obx(
        () => SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () {
            controller.onRefresh();
          },
          child: ListView.builder(
            itemCount: controller.datas.length,
            itemBuilder: (BuildContext context, int index) {
              var item = controller.datas[index];
              return _getListItem(index: index, title: item.title ?? "");
            },
          ),
        ),
      ),
    );
  }
}
