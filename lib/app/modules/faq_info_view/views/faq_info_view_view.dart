import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:beering/app/data/common_faq.dart';
import 'package:beering/public.dart';
import 'package:beering/utils/color_utils.dart';
import 'package:beering/views/base/base_pageview.dart';

import 'package:get/get.dart';

import '../controllers/faq_info_view_controller.dart';

class FaqInfoViewView extends GetView<FaqInfoViewController> {
  const FaqInfoViewView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return KBasePageView(
      titleStr: "faq_info".tr,
      body: HtmlWidget(
        Get.arguments,
        customWidgetBuilder: (element) {
          if (element.localName == "title") {
            return Container();
          }
        },
      ),

      // IntrinsicHeight(
      //   child: Container(
      //     alignment: Alignment.centerLeft,
      //     margin: EdgeInsets.only(left: 12.w, right: 12.w),
      //     padding: EdgeInsets.all(12.w),
      //     decoration: BoxDecoration(
      //       color: ColorUtils.fromHex("#FF000000"),
      //       borderRadius: BorderRadius.circular(14),
      //     ),
      //     child: Column(
      //       children: [
      //         Text(
      //           (Get.arguments as CommonFaqModel).title ?? "",
      //           style: Get.textTheme.displayLarge,
      //         ),
      //         12.columnWidget,
      //         Text(
      //           (Get.arguments as CommonFaqModel).content ?? "",
      //           style: Get.textTheme.bodyMedium,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
